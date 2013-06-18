class SessionsController < ApplicationController
require 'active_record'
require 'yaml'

  def create
    session[:access_token] = request.env['omniauth.auth']['credentials']['token']
    session[:access_secret] = request.env['omniauth.auth']['credentials']['secret']
    redirect_to show_path, notice: "Signed in"
  end

  def show
    if session['access_token'] && session['access_secret']
      @user = client.user(include_entities: true)

        dbconfig = YAML::load(File.open('config/database.yml'))
        ActiveRecord::Base.establish_connection(dbconfig)
        #each follower record consists of a user id, and then the id of the user following them.
        @savedrecords=Follower.where(:userid=>@user.id.to_s)

        currentfollowers=Twitter.followers
        @currentids=currentfollowers.map {|follower| follower.id.to_s }

        @savedids=@savedrecords.map {|record| record.followerid }

        #get difference, new followers
        @newfollowers=@currentids-@savedids

        #get difference, no longer followers
        @nolongerfollowers=@savedids-@currentids

    else
      redirect_to failure_path
    end
  end

  def savedata
    Follower.destroy_all(:userid => @user.id.to_s)
    @currentids.each do |id|
      Follower.create(:userid => @user.id.to_s, :followerid=>id)
    end
    redirect_to :back
  end

  def error
    flash[:error] = "Sign in with Twitter failed"
    redirect_to root_path
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "Signed out"
  end

end

class Follower < ActiveRecord::Base
end
