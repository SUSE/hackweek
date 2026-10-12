class ListEpisodesTool < MCP::Tool
  tool_name 'list_episodes'
  description 'List hackweek episodes with dates and the active flag.'
  input_schema(properties: {}, required: [])
  annotations(read_only_hint: true)

  def self.call(server_context:)
    # Public listing; the context is accepted for a uniform tool interface.
    _context = server_context
    entries = Episode.order(:start_date, :id).map { |episode| serialize(episode) }
    MCP::Tool::Response.new([{ type: 'text', text: JSON.generate(entries) }])
  end

  class << self
    private

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
