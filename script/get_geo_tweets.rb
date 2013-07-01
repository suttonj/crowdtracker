#!/usr/bin/env ruby
require 'tweetstream'
 
ENV["RAILS_ENV"] ||= "production"

root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
require File.join(root, "config", "environment")
#Rails.application.require_environment!
 
TweetStream.configure do |config|
  config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  config.oauth_token = ENV['TWITTER_OAUTH_TOKEN']
  config.oauth_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
  config.auth_method = :oauth
  config.parser = :json_gem
end
 
#TweetStream::Client.new.track('foursquare',
# San Franciso, Boston, New York, Houston, Seattle
#TweetStream::Client.new.locations([-123,36,-121,38,-71.18,42.23,-70.96,42.48,-74.27,40.57,-73.75,40.93,-95.86,29.43,-95.11,30.07,-122.43,47.51,-122.14,47.73],
 TweetStream::Client.new.locations([-71.18,42.23,-70.96,42.48,-74.27,40.57,-73.75,40.93],
  :delete    => Proc.new { |status_id, user_id|
    Rails.logger.info "[TweetStream] Requesting to delete: #{status_id}"
  },
  :limit     => Proc.new { |skip_count|
    Rails.logger.info "[TweetStream] Limiting: #{skip_count}"
  },
  :error     => Proc.new { |message|
    Rails.logger.info "[TweetStream][#{Time.now}] TweetStream error: #{message}"
  },
  :reconnect => Proc.new { |timeout, retries|
    Rails.logger.info "[TweetStream][#{Time.now}] Reconnect: #{timeout} secs on #{retries} retry"
  }
) do |status|
  Rails.logger.info "[TweetStream] Status: #{status.text}"
 
  # Parse out the (structured) tweet message.
  # If the message is unstructured, discard it
  # Grab only tweets from foursquare
  
  locations.each do |loc|
    if status.text.include?(loc)
    # Parse out the location name from the tweet
#     matching = /I'm at (.*?) (\(|w\/|http)/.match(status[:text])
#     matching ||= /\(@ (([^w]|w[^\/])*)(w\/.*)?\)/.match(status[:text])
# #    matching ||= /the mayor of (.*) on @foursquare/.match(status[:text])
 
#     if matching
#       status[:name] = matching[1]
#     end
 
#     status[:url] = /(http:\/\/[^ ]*)$/.match(status[:text])
#     if status[:url]
#       status[:url] = status[:url][1]
#     end
    Rails.logger.info "**%**&**[TweetStream] Status: #{status.text} ***%@&****"
 
    #ap status
    #if status[:geo] && status[:geo][:coordinates]
      
    #  rval = "date:#{DateTime.parse(status[:created_at])}\
    #          &lat:#{status[:geo][:coordinates][0]}\
    #          &long:#{status[:geo][:coordinates][1]}"
    #  Rails.logger.info "[#{status[:geo][:coordinates][0]}, #{status[:geo][:coordinates][1]}]"
      $redis.lpush(loc, status[:text])
      $redis.ltrim(loc, 0, 100)

      #Rails.logger.info "[TweetStream] Adding checkin: #{status[:name].strip}"
      #puts status[:name].strip
    end
  end
end