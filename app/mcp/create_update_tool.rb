class CreateUpdateTool < MCP::Tool
  tool_name 'create_update'
  description 'Post an update to a hackweek project you originate or belong to.'
  input_schema(
    properties: {
      project_id: { type: %w[string integer], description: 'Project id or url slug.' },
      text: { type: 'string', description: 'Update text.' }
    },
    required: %w[project_id text]
  )
  annotations(read_only_hint: false, destructive_hint: false)

  DENIED_MESSAGE = 'Not accessible through this server'.freeze

  def self.call(project_id:, text:, server_context:)
    user = user_from(server_context)
    return denied_response if guest?(user)
    return denied_response unless server_context[:scope] == 'write'

    project = find_project(project_id)
    return denied_response if project.nil? || !member_or_originator?(project, user)

    cleaned = text.to_s.strip
    return error_response('Update text must not be blank.') if cleaned.empty?

    update = Update.create!(author: user, project: project, text: cleaned)
    text_response("Created update #{update.id} on project '#{project.title}'.")
  rescue ActiveRecord::RecordInvalid => e
    error_response("Could not create update: #{e.record.errors.full_messages.to_sentence}.")
  end

  class << self
    private

    def user_from(server_context)
      server_context[:user] # Hash and MCP::ServerContext both answer #[]
    end

    def guest?(user)
      user.nil? || (user.respond_to?(:persisted?) && !user.persisted?)
    end

    def find_project(ref)
      Project.find_by(url: ref.to_s) || (ref.to_s.match?(/\A\d+\z/) ? Project.find_by(id: ref) : nil)
    end

    # Only originators and members may post; admins join first like
    # everyone else.
    def member_or_originator?(project, user)
      project.originator_id == user.id || project.memberships.exists?(user_id: user.id)
    end

    def text_response(text)
      MCP::Tool::Response.new([{ type: 'text', text: text }])
    end

    def error_response(text)
      MCP::Tool::Response.new([{ type: 'text', text: text }], error: true)
    end

    def denied_response
      MCP::Tool::Response.new([{ type: 'text', text: DENIED_MESSAGE }], error: true)
    end
  end
end
