class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def client
    Twitter.configure do |config|
      config.consumer_key = 'j1wLvQtdXPOaWN4HJVwKw'
      config.consumer_secret = 'JJ0ahgla4s99b9h5GLVme0IeKkw3tOqT4fcp22F1Q'
      config.oauth_token = session['access_token']
      config.oauth_token_secret = session['access_secret']
    end
  end

end