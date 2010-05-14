class ApplicationController
  YES = true
  NO = false
  
  attr_accessor :tweetsTableView, :tweetsTableDelegate
  
  def applicationDidFinishLaunching(notification)
    refreshTweets
    @timer = NSTimer.scheduledTimerWithTimeInterval(30,
                                                    target: self,
                                                    selector: :refreshTweets,
                                                    userInfo: nil,
                                                    repeats: YES)
  end
  
  def refreshTweets
    twitterService.refreshSearch
  end
  
  def twitterService
    @twitterService ||= TwitterService.new("%23telegraaf", self)
  end
  
  def newTweetsReceived(tweets)
    tweetsTableDelegate.tweets = tweets
  end
  
  def applicationShouldTerminate(sender)
    @timer.invalidate
    return NSTerminateNow
  end
end