module McpSpecHelpers
  DENIED_MESSAGE = 'Not accessible through this server'.freeze

  def call_tool(tool, args, user, scope: nil)
    delivered = JSON.parse(JSON.generate(args), symbolize_names: true)
    effective = scope.nil? ? (user.respond_to?(:persisted?) && user.persisted? ? 'write' : nil) : scope
    tool.call(**delivered, server_context: { user: user, scope: effective })
  end

  def response_text(response)
    response.content.map { |block| block[:text] || block['text'] }.join
  end

  def response_payload(response)
    JSON.parse(response_text(response))
  end

  def be_denied
    satisfy('uniform denial') do |response|
      response.error? && response_text(response) == DENIED_MESSAGE
    end
  end
end

RSpec.configure do |config|
  config.include McpSpecHelpers
end
