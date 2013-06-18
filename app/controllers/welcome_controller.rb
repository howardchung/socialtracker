class WelcomeController < ApplicationController
	if session['access_token'] && session['access_secret']
		redirect_to :controller=>"sessions", :action=>"show"
	end
end
