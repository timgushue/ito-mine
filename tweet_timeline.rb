#!/usr/bin/env ruby

=begin
 Takes twitter username as an argument and returns two CSV files,
 one with text from tweets and a second containing only URLs that were
 included in tweets.
=end


require 'rubygems'
require 'twitter'
require 'csv'


# twitter authentication 
Twitter.configure do |config|
  config.consumer_key = "YOUR_CONSUMER_KEY"
  config.consumer_secret = "YOUR_CONSUMER_SECRET"
  config.oauth_token = "YOUR_OAUTH_TOKEN"
  config.oauth_token_secret = "YOUR_OAUTH_TOKEN_SECRET"
end


# store the <username> 
twitter_username =  String.new ARGV[0]

# collect last 200 tweets from <username>
timeline = Twitter.user_timeline(twitter_username, :count => 200)
raw_tweets = timeline.map { |t| t.text}


# extract URLs from each tweet and remove any string quotes 
http_address = raw_tweets.map { |each| each.scan(/https?:\/\/[\S]+/) }
http_address.flatten!
http_address.map { |each| each.gsub!(/"/, "") }


# store complete tweet text as <username>_timeline.csv
CSV.open("#{twitter_username}_timeline.csv", 'w') { |csv| csv << raw_tweets }

# store the tweet URLs as <username>_http.csv
CSV.open("#{twitter_username}_http.csv", 'w') { |csv| csv << http_address }


