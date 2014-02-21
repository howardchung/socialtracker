class ApplicationController < ActionController::Base
  protect_from_forgery
require 'active_record'
ActiveRecord::Base.establish_connection(
          :adapter=> "postgresql",
          :pool=> 5,
          :database=> "d79rcco6km5fni",
          :username=> "qrcbvngsucryjg",
          :password=> ENV["DB_PASSWORD"],
          :host=> "ec2-23-21-91-97.compute-1.amazonaws.com"
          )

  private
  def client
    Twitter.configure do |config|
      config.consumer_key = ENV['CONSUMER_KEY']
      config.consumer_secret = ENV['CONSUMER_SECRET']
      config.oauth_token = session['access_token']
      config.oauth_token_secret = session['access_secret']
    end
  end

def seconds_to_units(seconds)
  '%d years, %d days, %d hours, %d minutes, %d seconds' %
    # the .reverse lets us put the larger units first for readability
    [365,24,60,60].reverse.inject([seconds]) {|result, unitsize|
      result[0,0] = result.shift.divmod(unitsize)
      result
    }
end

def fbauth
  @oauth = Koala::Facebook::OAuth.new(ENV["FB_APP_ID"], ENV["FB_APP_SECRET"], url_for(:controller=>"facebook", :action=>"getToken"))
end
  helper_method :seconds_to_units, :fbauth

end

class FBFriend < ActiveRecord::Base
end

class Follower < ActiveRecord::Base
end