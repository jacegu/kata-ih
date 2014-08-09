#encoding: utf-8

require 'sinatra/base'
require 'sinatra/json'
require 'multi_json'

require 'digest/sha2'
require 'mongo'
require 'pony'

require_relative 'config'

class UsersController < Sinatra::Base
  helpers Sinatra::JSON

  post '/account' do
    email = params[:email]
    db = Mongo::Connection.new(MONGO_HOST, MONGO_PORT).db(MONGO_DATABASE)
    accounts = db['accounts']

    if accounts.find_one(email: email) == nil
      encrypted_password = Digest::SHA256.hexdigest("#{params[:password]}#{SALT}")
      confirmation_token = Digest::MD5.hexdigest("#{email}#{SALT}")
      accounts.insert(
        email: email,
        password: encrypted_password,
        confirmation_token: confirmation_token,
        confirmed_at: nil,
        created_at: Time.now,
        last_signed_in_at: nil
      )
      send_verification_email(email, confirmation_token)
    else
      status 409
      json error: "Ya hay un usuario registrado con el email #{email}"
    end
  end

  private

  def send_verification_email(email, confirmation_token)
    Pony.mail(
      charset: 'utf-8',
      to:      email,
      from:    'hola@foobar.com <hola@foobar.com>',
      subject: 'Verifica tu cuenta de foobar',
      body:    %Q{
      Verifica tu email y accede a tu cuenta desde https://foobar.com/verification/#{confirmation_token}"

      ¡Muchas gracias!
      },
      via: :smtp,
      via_options: {
        address:              SMTP_HOST,
        port:                 SMTP_PORT,
        enable_starttls_auto: SMTP_USE_TTLS,
        user_name:            SMPT_USERNAME,
        password:             SMTP_PASSWORD,
        authentication:       :plain,
        domain:               "localhost.localdomain"
      }
    )
  end
end
