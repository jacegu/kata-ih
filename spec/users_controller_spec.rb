require 'http_spec_helper'
require 'users_controller'

describe UsersController do
  let(:mongo) do
    Mongo::Connection.new(MONGO_HOST, MONGO_PORT).db(MONGO_DATABASE)
  end

  before do
    mongo['accounts'].drop
  end

  it 'can post' do
    post_and_inspect '/account', email: 'yo@email', password: 'foobar'
    expect(last_response).to be_ok
  end
end
