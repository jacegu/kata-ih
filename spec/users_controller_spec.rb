require 'http_spec_helper'
require 'users_controller'

describe UsersController do
  let(:accounts) { mongo['accounts'] }
  let(:mongo) { Mongo::Connection.new(MONGO_HOST, MONGO_PORT).db(MONGO_DATABASE) }

  before { accounts.drop }

  describe 'creating an account' do
    context 'when the email is not taken' do
      it 'creates a new account' do
        post_and_inspect '/account', email: 'yo@email', password: 'foobar'
        expect(last_response).to be_ok
        expect(number_of_accounts).to eq(1)
      end
    end
  end

  def number_of_accounts
    accounts.count
  end
end
