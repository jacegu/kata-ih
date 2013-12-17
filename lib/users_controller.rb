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
    @e = params[:email]
    db = Mongo::Connection.new(MONGO_HOST, MONGO_PORT).db(MONGO_DATABASE)
    collection = db['accounts']
    if collection.find_one(email: @e) == nil
      p = params[:password]
      p2 = Digest::SHA256.hexdigest("#{p}#{SALT}")
      ct = Digest::MD5.hexdigest("#{@e}#{SALT}")
      collection.insert(
        email: @e,
        password: p2,
        confirmation_token: ct,
        confirmed_at: nil,
        created_at: Time.now,
        last_signed_in_at: nil
      )
      Pony.mail(
        charset: 'utf-8',
        to:      @e,
        from:    'hola@foobar.com <hola@foobar.com>',
        subject: 'Verifica tu cuenta de foobar',
        body:    %Q{
        Verifica tu email y accede a tu cuenta desde https://foobar.com/verification/#{ct}"

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
    else
      status 409
      json error: "Ya hay un usuario registrado con el email #{@e}"
    end
  end
end
