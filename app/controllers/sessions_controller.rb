class SessionsController < ApplicationController

  def create
    session[:access_token] = request.env['omniauth.auth']['credentials']['token']
    session[:access_secret] = request.env['omniauth.auth']['credentials']['secret']
    redirect_to show_path, notice: "Signed in"
  end

  def show
    if session['access_token'] && session['access_secret']
      @user = client.user(include_entities: true)

        dbconfig = YAML.load(ERB.new(File.read('config/database.yml')).result)
        ActiveRecord::Base.establish_connection(
          :adapter=> "postgresql",
          :pool=> 5,
          :database=> "d79rcco6km5fni",
          :username=> "qrcbvngsucryjg",
          :password=> ENV["DB_PASSWORD"],
          :host=> "ec2-23-21-91-97.compute-1.amazonaws.com"
          )

        #each follower record consists of a user id, and then the id of the user following them.
        @savedrecords=Follower.where(:userid=>@user.id)

        currentfollowers=Twitter.followers
        @currentids=currentfollowers.map {|follower| follower.id }
        @savedids=@savedrecords.map {|record| record.followerid }

        #get difference, new followers
        @newfollowers=@currentids-@savedids

        #get difference, no longer followers
        @nolongerfollowers=@savedids-@currentids

    else
      redirect_to failure_path
    end
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
