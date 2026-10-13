require 'rack/attack'

# Throttle MCP traffic: the search tool runs a full-table LIKE per request,
# so unbounded clients can saturate the database. Production shares the file
# cache across Puma workers on one host; the test suite swaps in a memory
# store (see spec/requests/mcp_spec.rb) because test runs null_store.
module Rack
  class Attack
    throttle('mcp/ip', limit: 300, period: 5.minutes) do |request|
      request.ip if request.path == '/mcp'
    end
  end
end
