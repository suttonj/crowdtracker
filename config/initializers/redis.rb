#!/usr/bin/env ruby

uri = URI.parse(ENV["REDISTOGO_URL"])
$redis = Redis.new(:host => uri.host, :port => uri.port)