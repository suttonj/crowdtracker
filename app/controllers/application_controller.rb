class ApplicationController < ActionController::Base
  protect_from_forgery

  require "twitter"
  require "engtagger"

  def twitter_auth
  	Twitter.configure do |config|
  		config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  		config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  		config.oauth_token = ENV['TWITTER_OAUTH_TOKEN']
  		config.oauth_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
	end
  	
  	TweetStream.configure do |config|
  		config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  		config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  		config.oauth_token = ENV['TWITTER_OAUTH_TOKEN']
  		config.oauth_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
		config.auth_method = :oauth
	end

  end

  def init_engtagger(locations)
    $tgr = EngTagger.new
    
    #locations = Location.all
    locations.each do |loc|
      $tgr.classify_unknown_word(loc.name)
    end

  end

  def engtagger(text)
  	#tgr = EngTagger.new
  	#tagged = tgr.add_tags(text)
  	#@nouns = tgr.get_proper_nouns(tagged)
  	@words = $tgr.get_words(text)
  end
end
