
class TweetParser
  def self.parse(json)
    tweet = JSON.parse(json)
  rescue => e
    #can't parse the tweet perhaps it's not well formed
    #or missing data due to stream window interruption
    return nil
  end
end
