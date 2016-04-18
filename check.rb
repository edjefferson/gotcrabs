require 'twitter'
require 'tempfile'
require 'RMagick'
include Magick
streamclient = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = ENV["YOUR_CONSUMER_KEY"]
  config.consumer_secret     = ENV["YOUR_CONSUMER_SECRET"]
  config.access_token        = ENV["YOUR_ACCESS_TOKEN"]
  config.access_token_secret = ENV["YOUR_ACCESS_SECRET"]
end
twitter_client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["YOUR_CONSUMER_KEY"]
  config.consumer_secret     = ENV["YOUR_CONSUMER_SECRET"]
  config.access_token        = ENV["YOUR_ACCESS_TOKEN"]
  config.access_token_secret = ENV["YOUR_ACCESS_SECRET"]
end

topics = ["#testhash141"]
streamclient.filter(track: topics.join(",")) do |object|
  if object.is_a?(Twitter::Tweet)
    name = object.user.name.split(" ")[0]
    screen_name = object.user.screen_name
    tweet_id = object.id
  
    words =""
    if name.length > 12
      words = "You've\ngot\ncrabs!"
    else
    words = "#{name},\nyou've\ngot\ncrabs!"
  end 
  puts words
    sleep 5
    
    text = Magick::Draw.new
    text.font_family = 'helvetica'
    text.pointsize = 52
    text.gravity = Magick::CenterGravity

    image = ImageList.new("crabs.jpg")

    colours = ["red","blue","green"]

       text.annotate(image, 0,0,-2,-2, words) {
            self.fill = 'white'
         }
         
         text.annotate(image, 0,0,2,2, words) {
              self.fill = 'white'
           }

           text.annotate(image, 0,0,0,0, words) {
                self.fill = colours.sample
             }

    temp = Tempfile.new("image")
    image.write("jpg:"+ temp.path)

    media_ids = %w(test.mp4).map do |filename|
      Thread.new do
        twitter_client.upload(File.new temp.path)
      end
    end.map(&:value)

    twitter_client.update("@#{screen_name}", :media_ids => media_ids.join(','), :in_reply_to_status_id => tweet_id)
end
end






