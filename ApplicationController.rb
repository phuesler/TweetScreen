class ApplicationController
  attr_accessor :tweetsTableView, :tweetsTableDelegate, :tweetTableCell
  
  def init
    if !super
      return nil
    end
    
    center = NSNotificationCenter.defaultCenter
    center.addObserver(self,
                       selector: :"handleTextColorChange:",
                       name: PreferencesController::TextColorChangedNotification,
                       object: nil)
   center.addObserver(self,
                      selector: :"handleBackgroundColorChange:",
                      name: PreferencesController::BackgroundColorChangedNotification,
                      object: nil)
    
    return self
  end
  
  def awakeFromNib
    refreshTweets
    handleTextColorChange(nil)
    handleBackgroundColorChange(nil)
  end
  
  def handleBackgroundColorChange(notification)
    tweetsTableView.backgroundColor = preferenceController.backgroundColor
  end
  
  def handleTextColorChange(notification)
    tweetTableCell.textColor = preferenceController.textColor
    # redraw table. FIXME: Find a better way to do this
    tweetsTableView.reloadData
  end
  
  def preferenceController
    unless @preferenceController
      @preferenceController = PreferencesController.alloc.init
    end
    @preferenceController
  end
  
  def showPreferencePanel(sender)
    preferenceController.showWindow(self)
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