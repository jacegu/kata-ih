require 'http_spec_helper'
require 'users_controller'

describe UsersController do
  let(:mongo) do
    db = Mongo::Connection.new(MONGO_HOST, MONGO_PORT).db(MONGO_DATABASE)
    db
  end

  before do
    mongo['accounts'].drop
  end

  it 'can post' do
    post '/account', email: 'yo@email', password: 'foobar'
    puts last_response.body
    expect(last_response).to be_ok
  end
end
