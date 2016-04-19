require 'twitter'
require 'tempfile'
require 'rmagick'
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

topics = ["#WhatPasteAmI"]
streamclient.filter(track: topics.join(",")) do |object|
  if object.is_a?(Twitter::Tweet)
    puts object
    name = object.user.name.split(" ")[0]
    if name == "The"
      name = object.user.name.split(" ")[1]
    end
    screen_name = object.user.screen_name
    if screen_name != "ShippamsPaste"
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

    twitter_client.update("@#{screen_name} #WhatPasteAmI", :media_ids => media_ids.join(','), :in_reply_to_status_id => tweet_id)
end
end
end





