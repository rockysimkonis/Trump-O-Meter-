require 'json'

get '/' do
  erb :index
end

get '/tweets' do
  #add button to get new score in front end


  #once button is clicked database is called and the following unloaded
  # - get_donald
  # - calculate all tweets
  # - return integer/string to be udpated in the view
  if request.xhr?
    content_type :json
    tweets = Tweet.most_recent
    @data = {
      :latest_tweet => tweets,
      :average_score => Tweet.sentiment_for_tweets(tweets)
    }
    return @data.to_json
  else
    erb :index
  end
end
