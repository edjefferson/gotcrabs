require 'twitter'
require 'tempfile'
puts ENV["YOUR_CONSUMER_KEY"]
twitter_client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["YOUR_CONSUMER_KEY"]
  config.consumer_secret     = ENV["YOUR_CONSUMER_SECRET"]
  config.access_token        = ENV["YOUR_ACCESS_TOKEN"]
  config.access_token_secret = ENV["YOUR_ACCESS_SECRET"]
end




require 'RMagick'

include Magick



words = "chips \n in \n brown \n gravy"

text = Magick::Draw.new
text.font_family = 'helvetica'
text.pointsize = 52
text.gravity = Magick::CenterGravity

image = ImageList.new("test.png")

 text.annotate(image, 0,0,0,0, words) {
      self.fill = 'darkred'
   }

temp = Tempfile.new("image")
image.write("png:"+ temp.path)

media_ids = %w(test.mp4).map do |filename|
  Thread.new do
    twitter_client.upload(File.new temp.path)
  end
end.map(&:value)

twitter_client.update("Tweet text", :media_ids => media_ids.join(','))