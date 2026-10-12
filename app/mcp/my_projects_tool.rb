class MyProjectsTool < MCP::Tool
  tool_name 'my_projects'
  description "List the calling user's originated and joined hackweek projects."
  input_schema(properties: {}, required: [])
  annotations(read_only_hint: true)

  DENIED_MESSAGE = 'Not accessible through this server'.freeze

  def self.call(server_context:)
    user = user_from(server_context)
    return denied_response if guest?(user)

    ability = Ability.new(user)
    originated = user.originated_projects.order(:id).limit(100).select { |project| ability.can?(:read, project) }
    membered = user.projects.distinct.where.not(id: user.originated_projects.unscope(:order).select(:id))
                   .order(:id).limit(100).select { |project| ability.can?(:read, project) }
    entries = originated.map { |project| serialize(project, 'originator') } +
              membered.map { |project| serialize(project, 'member') }
    text_response(JSON.generate(entries))
  end

  class << self
    private

    def user_from(server_context)
      server_context[:user] # Hash and MCP::ServerContext both answer #[]
    end

    def guest?(user)
      user.nil? || (user.respond_to?(:persisted?) && !user.persisted?)
    end

    def serialize(project, role)
      { id: project.id, title: project.title, url: project.url, role: role }
    end

    def text_response(text)
      MCP::Tool::Response.new([{ type: 'text', text: text }])
    end

    def denied_response
      MCP::Tool::Response.new([{ type: 'text', text: DENIED_MESSAGE }], error: true)
    end
  end
end
