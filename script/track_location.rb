#!/usr/bin/env ruby

require 'tweetstream'
#require 'active_record'

ENV["RAILS_ENV"] ||= "production"

root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
require File.join(root, "config", "environment")

TweetStream.configure do |config|
	config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
	config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
	config.oauth_token = ENV['TWITTER_OAUTH_TOKEN']
	config.oauth_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
	config.auth_method = :oauth
end

daemon = TweetStream::Daemon.new('tracker', :log_output => true)
daemon.on_inited do
  ActiveRecord::Base.connection.reconnect!
end

daemon.locations([-71.197586, 42.285945], [-70.995026, 42.430045])
locations = Location.all.map(&:name) 
puts locations.first
locations.each do |location|
	daemon.track(location) do |tweet|
		puts tweet.text
	  	tweet_id = Digest::MD5.hexdigest(tweet.text)
		#$redis.sadd("topic:@justinbieber:tweets", tweet_id)
		#$redis.sadd("tweet:#{tweet_id}:topic", "@justinbieber")
		$redis.lpush(location.name, tweet.text)
		$redis.ltrim(location.name, 0, 100)
	  	#members = $redis.smembers("topic:@justinbieber:tweets").count
	  	members = $redis.llen(location.name)
	  	puts "# of tweets for #{location.name}: #{members}"
	end
end