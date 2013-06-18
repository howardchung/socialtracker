class DataController < ApplicationController
  
  def save
    Follower.where(:userid=>params[:userid]).delete_all
    JSON.parse(params[:currentids]).each do |id|
      Follower.create(:time => Time.now) do |f|
      	f.userid=params[:userid]
		f.followerid=id
      end
    end
    redirect_to :back
  end

end