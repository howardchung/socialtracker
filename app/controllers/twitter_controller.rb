class TwitterController < ApplicationController

  def create
    session[:access_token] = request.env['omniauth.auth']['credentials']['token']
    session[:access_secret] = request.env['omniauth.auth']['credentials']['secret']
    redirect_to show_path, notice: "Signed in"
  end

  def show

    if session['access_token'] && session['access_secret']
      @user = client.user(include_entities: true)

        @currentfollowers=Twitter.followers
        @currentfriends=Twitter.friends

        #each follower record consists of a user id, and then the id of the user following them.
        @savedrecords=Follower.where(:userid=>@user.id.to_s)

        #followers follow the user, followees are followed by user
        followers={}
        saved={}
        followees={}
        @currentfollowers.each do |follower|
          followers[follower.id.to_s]=follower.name
        end

        @savedrecords.each do |record|
          saved[record.followerid]=record.followername
        end

        @currentfriends.each do |friend|
          followees[friend.id.to_s]=friend.name
        end

        #create hash of tables to build
        @datahash={}

        #get difference, new followers
        @datahash["New followers"]=followers.select {|key,value| (followers.keys-saved.keys).include?(key) }

        #get difference, no longer followers
        @datahash["No longer followers"]=saved.select {|key,value| (saved.keys-followers.keys).include?(key) }

        #friends who don't follow user
        @datahash["Friends not following you"]=followees.select {|key,value| (followees.keys-followers.keys).include?(key) }

        #friends who aren't followed by user
        @datahash["Friends you don't follow"]=followers.select {|key,value| (followers.keys-followees.keys).include?(key) }

    #TODO won't update names in database if user changes them
#update the database
#remove no longer friends
@datahash["No longer followers"].each do |key,value|
 Follower.where(:userid=>@user.id.to_s).where(:followerid=>key).delete_all
end

#add new friends
@datahash["New followers"].each do |key, value|
    Follower.create(:time => Time.now) do |f|
        f.userid=@user.id.to_s
        f.username=@user.name
        f.followerid=key
        f.followername=value
      end
    end
        ActiveRecord::Base.connection.close
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
