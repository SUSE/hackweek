class ListProjectsTool < MCP::Tool
  tool_name 'list_projects'
  description 'List hackweek projects, scoped to the active episode by default.'
  input_schema(
    properties: {
      episode: {
        type: %w[string integer],
        description: 'Episode id to scope to, or "all" for every episode. Defaults to the active episode.'
      },
      limit: {
        type: 'integer',
        description: 'Maximum number of projects to return (default 20, max 100).'
      }
    },
    required: []
  )
  annotations(read_only_hint: true)

  DENIED_MESSAGE = 'Not accessible through this server'.freeze
  DEFAULT_LIMIT = 20
  MAX_LIMIT = 100

  def self.call(server_context:, episode: nil, limit: DEFAULT_LIMIT)
    ability = Ability.new(user_from(server_context))
    projects = scope_to_episode(Project.includes(:originator).order(:id), episode)
    return error_response('Unknown episode.') if projects.nil?

    clamped = clamp_limit(limit)
    candidates = projects.limit(clamped * 5)
    visible = candidates.select { |project| ability.can?(:read, project) }.first(clamped)
    text_response(JSON.generate(visible.map { |project| serialize(project) }))
  end

  class << self
    private

    def user_from(server_context)
      server_context[:user] # Hash and MCP::ServerContext both answer #[]
    end

    def scope_to_episode(projects, episode)
      return scope_to_active(projects) if episode.nil? || episode.to_s.strip.empty?
      return projects if episode.to_s.strip.casecmp?('all')

      found = Episode.find_by(id: episode)
      return nil if found.nil?

      projects.by_episode(found)
    end

    def scope_to_active(projects)
      active = Episode.active
      active ? projects.by_episode(active) : Project.none
    end

    def clamp_limit(limit)
      clamped = Integer(limit, exception: false)
      return DEFAULT_LIMIT if clamped.nil? || clamped <= 0
      return MAX_LIMIT if clamped > MAX_LIMIT

      clamped
    end

    def serialize(project)
      {
        id: project.id,
        title: project.title,
        url: project.url,
        state: project.aasm_state,
        originator: project.originator&.name,
        member_count: project.memberships_count.to_i
      }
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
