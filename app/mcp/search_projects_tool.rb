class SearchProjectsTool < MCP::Tool
  tool_name 'search_projects'
  description 'Search hackweek projects by title, description and keywords.'
  input_schema(
    properties: {
      query: { type: 'string', description: 'Free-text query matched against title, description and keywords.' }
    },
    required: ['query']
  )
  annotations(read_only_hint: true)

  RESULT_LIMIT = 20

  # NOTE: LIKE-based search only. Upgrade to ThinkingSphinx once searchd is
  # available in the test env; the models already maintain real-time indices.
  def self.call(query:, server_context:)
    ability = Ability.new(user_from(server_context))
    return text_response(JSON.generate([])) unless query.is_a?(String)

    # Reads are currently unconditional, so SQL-limit to the result size; the
    # Ruby select stays as a guard so future per-project rules filter here.
    matches = search(query).limit(RESULT_LIMIT).select { |project| ability.can?(:read, project) }
    text_response(JSON.generate(matches.map { |project| serialize(project) }))
  end

  class << self
    private

    def user_from(server_context)
      server_context[:user] # Hash and MCP::ServerContext both answer #[]
    end

    def search(query)
      term = query.strip.truncate(200)
      return Project.none if term.empty?

      # LIKE search capped at 200 chars; the site search is equally public,
      # so no extra throttling here.
      pattern = "%#{ActiveRecord::Base.sanitize_sql_like(term.downcase)}%"
      conditions = ['LOWER(projects.title) LIKE :pattern',
                    'LOWER(projects.description) LIKE :pattern',
                    'LOWER(keywords.name) LIKE :pattern'].join(' OR ')
      Project.left_joins(:keywords).where(conditions, pattern: pattern).distinct.order(:id)
    end

    def serialize(project)
      { id: project.id, title: project.title, url: project.url, state: project.aasm_state }
    end

    def text_response(text)
      MCP::Tool::Response.new([{ type: 'text', text: text }])
    end
  end
end
