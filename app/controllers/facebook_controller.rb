class FacebookController < ApplicationController

def show

@token=session[:fbtoken]

#get data from API
@graph = Koala::Facebook::API.new(@token)
@user = @graph.get_object("me")
@likes = @graph.get_connections("me", "likes")
@currentfriends = @graph.get_connections("me", "friends")

@savedrecords=FBFriend.where(:userid=>@user["id"].to_s)

friends={}
saved={}
@currentfriends.each do |friend|
  friends[friend["id"].to_s]=friend["name"]
end

@savedrecords.each do |record|
  saved[record.friendid]=record.friendname
end

#create hash of tables to build
@datahash={}

#get difference, new
@datahash["New friends"]=friends.select {|key,value| (friends.keys-saved.keys).include?(key) }

#get difference, no longer
@datahash["No longer friends"]=saved.select {|key,value| (saved.keys-friends.keys).include?(key) }

#TODO won't update names in database if user changes them
#update the database
#remove no longer friends
@datahash["No longer friends"].each do |key,value|
FBFriend.where(:userid=>@user["id"].to_s).delete_all
end

#add new friends
@datahash["New friends"].each do |key, value|
    Follower.create(:time => Time.now) do |f|
 		f.userid=@user["id"].to_s
        f.username=@user["name"]
        f.followerid=key
        f.followername=value
      end
    end

end

def getToken
session[:fbtoken]=fbauth.get_access_token(params[:code])
redirect_to :action=>"show"
end



end