require 'twitter'
puts ENV["YOUR_CONSUMER_KEY"]
twitter_client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["YOUR_CONSUMER_KEY"]
  config.consumer_secret     = ENV["YOUR_CONSUMER_SECRET"]
  config.access_token        = ENV["YOUR_ACCESS_TOKEN"]
  config.access_token_secret = ENV["YOUR_ACCESS_SECRET"]
end



media_ids = %w(test.mp4).map do |filename|
  Thread.new do
    twitter_client.upload(File.new(filename))
  end
end.map(&:value)

twitter_client.update("Tweet text", :media_ids => media_ids.join(','))