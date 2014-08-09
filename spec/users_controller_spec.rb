require 'http_spec_helper'
require 'accounts_controller'

describe AccountsController do
  let(:accounts) { mongo['accounts'] }
  let(:mongo) { Mongo::Connection.new(MONGO_HOST, MONGO_PORT).db(MONGO_DATABASE) }

  before { accounts.drop }

  describe 'creating an account' do
    context 'when the email is not taken' do
      it 'creates a new account' do
        create_account(email: 'yo@email', password: 'foobar')
        expect(last_response).to be_ok
        expect(number_of_accounts).to eq(1)
      end
    end

    context 'when the email is taken' do
      before { create_account(email: 'yo@email', password: 'foobar') }

      it 'does not create a new account' do
        create_account(email: 'yo@email', password: 'foobar')
        expect(last_response).not_to be_ok
        expect(number_of_accounts).to eq(1)
      end
    end
  end

  def create_account(account_data)
    post_and_inspect '/account', account_data
  end

  def number_of_accounts
    accounts.count
  end
end
