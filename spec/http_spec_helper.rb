require "rack/test"

module HttpTestingFacilities
  include Rack::Test::Methods

  def app
    APP
  end

  def post_and_inspect(*params)
    post *params
    puts "\nResponse:\n#{last_response.body.inspect}\n-----\n\n"
  end

  APP = Rack::Builder.parse_file('config.ru').first
end

RSpec.configure do |config|
  config.include(HttpTestingFacilities)
end
