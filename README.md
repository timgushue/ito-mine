Use Ruby and R generate a word cloud of a users last 200 tweets.

## Package Requirements
    
This was tested with Ruby(1.9.3p392) and R(3.0.1).  

Ruby Gems:
rubygems
twitter
csv

R Packages:
methods
Rcpp
RColorBrewer
tm
SnowballC
wordcloud

## Quick Start Guide

First, register your application with Twitter.

Then, copy and paste in your OAuth data.

```ruby
Twitter.configure do |config|
  config.consumer_key = YOUR_CONSUMER_KEY
  config.consumer_secret = YOUR_CONSUMER_SECRET
  config.oauth_token = YOUR_OAUTH_TOKEN
  config.oauth_token_secret = YOUR_OAUTH_TOKEN_SECRET
end
```

To run:
```ruby
timeline.rb <username>
```

A PDF will be generated as <username>_timeline.pdf
