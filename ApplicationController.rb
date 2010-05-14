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
  center.addObserver(self,
                     selector: :"handleTwitterSearchQueryChange:",
                     name: PreferencesController::TwitterSearchQueryChangedNotification,
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
  
  def handleTwitterSearchQueryChange(notification)
    twitterService.cancel!
    tweetsTableDelegate.tweets = []
    refreshTweets
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
    statusLabel.stringValue = "Updating tweets for: #{preferenceController.twitterSearchQuery}"
    twitterService.refreshSearch
  end
  
  def twitterService
    if @twitterService.nil? || @twitterService.cancelled?
      @twitterService = TwitterService.new(preferenceController.twitterSearchQuery, delegate: self, refreshInterval: 30)
    end
    @twitterService
  end
  
  def newTweetsReceived(tweets)
    tweetsTableDelegate.tweets = tweets + tweetsTableDelegate.tweets
    statusLabel.stringValue = "Finished updating tweets"
  end
  
  def convertColor(color)
    CGColorCreateGenericRGB(color.redComponent, color.greenComponent, color.blueComponent, 1)
  end
end