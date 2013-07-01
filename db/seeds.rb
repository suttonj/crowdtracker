# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'factory_girl'

FactoryGirl.define do
	factory :location, class: Location do
		name ''
		lat 42.3583
		long 71.0603
	end
end

FactoryGirl.create(:location, :name => "ocean club")
FactoryGirl.create(:location, :name => "house of blues")
FactoryGirl.create(:location, :name => "ned devine's")

FactoryGirl.create(:location, :name => "governor's ball")
FactoryGirl.create(:location, :name => "gov ball")
FactoryGirl.create(:location, :name => "randall island")