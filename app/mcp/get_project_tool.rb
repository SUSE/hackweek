class GetProjectTool < MCP::Tool
  tool_name 'get_project'
  description 'Show a hackweek project with members, keywords and readable updates.'
  input_schema(
    properties: {
      id: { type: %w[string integer], description: 'Project url slug (see the url field of list_projects) or id.' }
    },
    required: ['id']
  )
  annotations(read_only_hint: true)

  DENIED_MESSAGE = 'Not accessible through this server'.freeze
  RECENT_UPDATE_LIMIT = 10

  def self.call(id:, server_context:)
    user = user_from(server_context)
    ability = Ability.new(user)
    project = find_project(id)
    return denied_response if project.nil? || !ability.can?(:read, project)

    text_response(JSON.generate(serialize(project, ability)))
  end

  class << self
    private

    def user_from(server_context)
      server_context[:user] # Hash and MCP::ServerContext both answer #[]
    end

    def find_project(ref)
      scoped = Project.includes(:originator, :users, :keywords)
      scoped.find_by(url: ref.to_s) || (ref.to_s.match?(/\A\d+\z/) ? scoped.find_by(id: ref) : nil)
    end

    def serialize(project, ability)
      {
        id: project.id,
        title: project.title,
        description: project.description,
        state: project.aasm_state,
        url: project.url,
        originator: project.originator&.name,
        members: project.users.map(&:name),
        keywords: project.keywords.map(&:name),
        recent_updates: readable_updates(project, ability)
      }
    end

    def readable_updates(project, ability)
      updates = project.updates.includes(:author).order(created_at: :desc).limit(RECENT_UPDATE_LIMIT * 3)
      updates.select { |update| ability.can?(:read, update) }.first(RECENT_UPDATE_LIMIT).map do |update|
        { author: update.author&.name, text: update.text }
      end
    end

    def text_response(text)
      MCP::Tool::Response.new([{ type: 'text', text: text }])
    end

    def denied_response
      MCP::Tool::Response.new([{ type: 'text', text: DENIED_MESSAGE }], error: true)
    end
  end
end
