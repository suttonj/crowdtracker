class TweetController < ApplicationController

	def index
		TweetStream::Client.new.track('ocean club', 'armin') do |status|
		  puts "#{status.text}"
		end
	end

	private

	def twitter_search_locations
		long = -71.0603
	  	lat  = 42.3583
	  	
	  	#@locations = Location.pluck(:name)
	  	@locations = Location.all

	  	@locations.each do |location|
	  		@tweets = Twitter.search(location.name, :lang => "en", :count => 100, :geocode => "#{lat},#{long},20mi" ).results
	  		@tweets.each do |tweet|
	  			if tweet.to_s == ""
	  				puts "ERROR EMPTY TWEET"
	  				next
	  			end
	  			puts "Tweet: "
	  			puts tweet.text 
		  		@t = Tweet.new(:text => tweet.text)
		  		if @t.save!

			  		engtagger(tweet.text)
			  		@words.each do |key, value|
			  			puts key.downcase
			  			if location.name.eql?(key.downcase)
			  				@mention = Mention.new(:tweet_id => @t.id, :location_id => location.id)
			  				@mention.save!
			  				puts "******#{key.downcase}*****"
			  			end
			  		end
			  	else
			  		puts "ERROR SAVING TWEET"
			  	end
		  	end
		end
	end
end
