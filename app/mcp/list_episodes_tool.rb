class ListEpisodesTool < MCP::Tool
  tool_name 'list_episodes'
  description 'List hackweek episodes with dates and the active flag.'
  input_schema(properties: {}, required: [])
  annotations(read_only_hint: true)

  DENIED_MESSAGE = 'Not accessible through this server'.freeze

  def self.call(server_context:)
    ability = Ability.new(user_from(server_context))
    return denied_response unless ability.can?(:read, Episode)

    entries = Episode.order(:start_date, :id).limit(100).map { |episode| serialize(episode) }
    MCP::Tool::Response.new([{ type: 'text', text: JSON.generate(entries) }])
  end

  class << self
    private

    def user_from(server_context)
      server_context[:user]
    end

    def denied_response
      MCP::Tool::Response.new([{ type: 'text', text: DENIED_MESSAGE }], error: true)
    end

    def serialize(episode)
      {
        id: episode.id,
        title: episode.name,
        start_date: episode.start_date&.iso8601,
        end_date: episode.end_date&.iso8601,
        active: episode.active == true
      }
    end
  end
end
