#! /usr/bin/env ruby

=begin
 This is a temporary wrapper that calls subprograms to facilitate
 the transition to a more modular design. This program takes a 
 twitter username as the first (and only) argument. 
=end


require 'rubygems'


# check for the username
if ARGV.empty?
  puts "ito_mine.rb needs a twitter username for the first argument as folows: "
  puts "$ ruby ito_miner.rb <twitter_username> "
  exit
end

# store the username
twitter_username =  String.new ARGV[0]


# SYSTEM CALLS

# pull twitter timeline tweets and URLs into two CSV files
`ruby tweet_timeline.rb #{twitter_username} `

# all the analytical heavy lifting is done in R 
`R CMD BATCH --no-save --no-restore "--args #{twitter_username}" textmine.r #{twitter_username}.Rout`

# clean up by removing all the <twitter_username> files 
`rm #{twitter_username}_timeline.csv`
`rm #{twitter_username}_http.csv`
`rm #{twitter_username}.Rout`