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

  def engtagger(text)
  	tgr = EngTagger.new
  	tagged = tgr.add_tags(text)
  	@nouns = tgr.get_nouns(tagged)
  	@words = tgr.get_words(text)
  end
end
