#!/usr/bin/env ruby

uri = URI.parse(ENV["REDISTOGO_URL"])
$redis = Redis.new(:host => uri.host, :port => uri.port, :password => "2dd76293e8371cbd9bfbe2000371ce2e")