require 'json'

class ApplicationController
  YES = true
  NO = false
  
  attr_accessor :tweetsTableView
  
  def init
    if !super
      return nil
    else
      @timeline = []
      return self
    end
  end
  
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
    NSLog("tt: #{tweets.inspect}")
    @timeline = tweets
    tweetsTableView.reloadData
  end
  
  def numberOfRowsInTableView(tableView)
    @timeline.size
  end
  
  def tableView(tableView, objectValueForTableColumn: column, row: row)
    @timeline[row].valueForKey(column.identifier.to_sym)
  end
  
  def applicationShouldTerminate(sender)
    @timer.invalidate
    return NSTerminateNow
  end
end