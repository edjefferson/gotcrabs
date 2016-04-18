


streamclient = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = ENV["YOUR_CONSUMER_KEY"]
  config.consumer_secret     = ENV["YOUR_CONSUMER_SECRET"]
  config.access_token        = ENV["YOUR_ACCESS_TOKEN"]
  config.access_token_secret = ENV["YOUR_ACCESS_SECRET"]
end


topics = ["#shippamspaste"]
streamclient.filter(track: topics.join(",")) do |object|
  puts object.text if object.is_a?(Twitter::Tweet)
end


require 'RMagick'

include Magick





	image = ImageList.new("crabs.jpg")

	cat.rotate!(angle)
	cat.trim!

	cat.write("pics/#{angle}.jpg")
