class Location < ActiveRecord::Base

  	attr_accessible :lat, :long, :name
#  	has_many :tweets, through: :mentions, source: :tweet
#  	has_many :mentions, foreign_key: "location_id"


	def tag!(tweet)
		tweet_id = Digest::MD5.hexdigest(tweet)
		$redis.sadd("location:#{self.id}:tweets", tweet_id)
	end

	def numtags
		tags = $redis.smembers("location:#{self.id}:tweets")
		tags.count
	end
end
