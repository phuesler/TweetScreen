class ApplicationController
  attr_accessor :contentView, :tweetsTableView, :tweetsTableDelegate, :tweetTableCell, :statusLabel
  
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
  
  def toggleFullScreen(sender)
    if contentView.isInFullScreenMode
      contentView.exitFullScreenModeWithOptions(nil)
    else
      contentView.enterFullScreenMode(contentView.window.screen,withOptions:nil)
    end
  end
  
  def handleBackgroundColorChange(notification)
    statusLabel.backgroundColor = preferenceController.backgroundColor
    tweetsTableView.backgroundColor = preferenceController.backgroundColor
  end
  
  def handleTextColorChange(notification)
    tweetTableCell.textColor = preferenceController.textColor
    # redraw table. FIXME: Find a better way to do this
    tweetsTableView.reloadData
    statusLabel.textColor = preferenceController.textColor
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
    statusLabel.stringValue = "Updating tweets"
    twitterService.refreshSearch
  end
  
  def twitterService
    @twitterService ||= TwitterService.new("%23telegraaf", delegate: self, refreshInterval: 30)
  end
  
  def newTweetsReceived(tweets)
    tweetsTableDelegate.tweets = tweets
    statusLabel.stringValue = "Finished updating tweets"
  end
  
  def convertColor(color)
    CGColorCreateGenericRGB(color.redComponent, color.greenComponent, color.blueComponent, 1)
  end
end