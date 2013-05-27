class HomeController < ApplicationController

	before_filter :twitter_auth

  	def index
  		
  		@firstpost = Twitter.user_timeline("developerworks").first.text
  		@location= Twitter.user("MTimJones").location

	  	long = -71.0603
	  	lat  = 42.3583
	  	@tweets = Twitter.search("ocean club", :lang => "en", :count => 10, :geocode => "#{lat},#{long},50mi" ).results

  	end
end
