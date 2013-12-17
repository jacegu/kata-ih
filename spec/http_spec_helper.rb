require "rack/test"

module HttpTestingFacilities
  include Rack::Test::Methods

  def app
    APP
  end

  APP = Rack::Builder.parse_file('config.ru').first
end

RSpec.configure do |config|
  config.include(HttpTestingFacilities)
end
