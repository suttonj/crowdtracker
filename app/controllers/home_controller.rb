class HomeController < ApplicationController

	before_filter :twitter_auth

  	def index
  		$redis.flushdb #reset redis db
  		
  		@locations = Location.all
  		init_engtagger(@locations)

	  	long = -71.0603
	  	lat  = 42.3583
	  	
	  	#@locations = Location.pluck(:name)
	  	get_tweets_for(@locations, long, lat)
	  	
  	end


  	private 

  	def get_tweets_for(locations, long, lat)

  		locations.each do |location|
	  		if $max_id.nil?
	  			@tweets = Twitter.search(location.name, :lang => "en", :count => 100, :geocode => "#{lat},#{long},1000mi" ).results
	  		else
	  			@tweets = Twitter.search(location.name, :lang => "en", :count => 100, :max_id => $max_id, :geocode => "#{lat},#{long},100mi" ).results
	  		end
	  		
	  		@tweets.each do |tweet|
	  			if tweet.to_s == ""
	  				puts "ERROR EMPTY TWEET"
	  				next
	  			end
	  			puts tweet.text
			  	tweet_hash = Digest::MD5.hexdigest(tweet.text)
				
		  		engtagger(tweet.text)
		  		@words.each do |key, value|
		  			puts key.downcase
		  			if location.name.eql?(key.downcase)
		  				$redis.lpush(location.name, tweet.text)
						$redis.ltrim(location.name, 0, 500)
					  	members = $redis.llen(location.name)
					  	puts "# of tweets for #{location.name}: #{members}"
		  			end
		  		end
		  	end

		  	if @tweets.length > 99
		  		$max_id = @tweets.last.id
	  			puts "Max ID: #{@max_id}"
	  		end
		end
	end
end
