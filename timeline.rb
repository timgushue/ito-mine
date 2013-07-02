#!/usr/bin/env ruby
require 'rubygems'
require 'twitter'
require 'csv'


# twitter authentication 
Twitter.configure do |config|
  config.consumer_key = # "YOUR CONSUMER KEY"
  config.consumer_secret = # "YOUR CONSUMER SECRET"
  config.oauth_token = # "YOUR TOKEN"
  config.oauth_token_secret = # "YOUR TOKEN SECRET"
end


# store <username> 
screen_name =  String.new ARGV[0]
data =[]

# collect last 200 tweets and store them as <username>_timeline.csv
timeline = Twitter.user_timeline(screen_name, :count => 200)
timeline.each do |t|
	data << t.text
end
CSV.open("#{screen_name}_timeline.csv", 'w') do |csv|
	csv << data
end

# text mine with the system call: Rscript tm_timeline.r 'argv <- "<username>"')
`Rscript tm_timeline.r 'argv <- "#{screen_name}"'`

# remove <username>_timeline.csv 
`rm #{screen_name}_timeline.csv`