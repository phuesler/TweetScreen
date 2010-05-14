class ApplicationController
  attr_accessor :tweetsTableView, :tweetsTableDelegate
  
  def applicationDidFinishLaunching(notification)
    refreshTweets
  end
  
  def refreshTweets
    twitterService.refreshSearch
  end
  
  def twitterService
    @twitterService ||= TwitterService.new("%23telegraaf", delegate: self, refreshInterval: 30)
  end
  
  def newTweetsReceived(tweets)
    tweetsTableDelegate.tweets = tweets
  end
end