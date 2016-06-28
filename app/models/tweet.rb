# require './alchemyapi'
# alchemyapi = AlchemyAPI.new()

class Tweet < ActiveRecord::Base

  def self.get_donald
    topics = ["trump"]
    $client.filter(track: topics.join(",")) do |object|
      @tweet = object.text if object.is_a?(Twitter::Tweet)
      tweet = Tweet.create(body: @tweet, score: nil)
      puts "Added Tweet: #{tweet}"
    end

  end

  def self.analyze_sentiment(tweet_text)
    response = HTTParty.post("http://gateway-a.watsonplatform.net/calls/text/TextGetTextSentiment",
      { body: {apikey: "57283d014a02f4a6396c3cef8a88dc9e41e893c4", text: tweet_text, outputMode: "json"},
        headers: {"Content-Type" => "application/x-www-form-urlencoded"}
      }
    )
    if response["docSentiment"] && response["docSentiment"]["score"]
      ((response["docSentiment"]["score"]) * 20).to_f.round(2)
    else
      0
    end
  end

  def self.most_recent(limit = 10)
    Tweet.order(id: :desc).limit(limit)
  end

  def self.sentiment_for_tweets(tweets)
    tweet_text = tweets.map { | tweet| tweet.body }.join("\n")
    analyze_sentiment(tweet_text)
  end

end
