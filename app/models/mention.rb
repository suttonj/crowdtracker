class Mention < ActiveRecord::Base
  attr_accessible :location_id, :tweet_id

  belongs_to :location, class_name: "Location"
  belongs_to :tweet, class_name: "Tweet"

  validates :location_id, presence: true
  validates :tweet_id, presence: true
end
