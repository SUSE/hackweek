class JoinProjectTool < MCP::Tool
  tool_name 'join_project'
  description 'Join a hackweek project as a member.'
  input_schema(
    properties: {
      project_id: { type: %w[string integer], description: 'Project id or url slug.' }
    },
    required: ['project_id']
  )
  annotations(read_only_hint: false, destructive_hint: false, idempotent_hint: true)

  DENIED_MESSAGE = 'Not accessible through this server'.freeze

  def self.call(project_id:, server_context:)
    user = user_from(server_context)
    return denied_response if guest?(user)
    return denied_response unless server_context[:scope] == 'write'

    ability = Ability.new(user)
    project = find_project(project_id)
    return denied_response if project.nil? || !ability.can?(:read, project) || !ability.can?(:join, project)
    return text_response("Already a member of project '#{project.title}'.") if project.users.exists?(user.id)

    begin
      if project.join!(user)
        text_response("Joined project '#{project.title}'.")
      else
        error_response(project.errors.full_messages.to_sentence.presence || 'Could not join project.')
      end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique, AASM::InvalidTransition => e
      error_response("Could not join project: #{e.message}")
    end
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
