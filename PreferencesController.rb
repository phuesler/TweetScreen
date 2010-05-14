class PreferencesController < NSWindowController
  BackgroundColorKey = 'backgroundColor'
  TextColorKey = 'textColor'
  TwitterSearchQueryKey = 'twitterSearchQuery'
  BackgroundColorChangedNotification = 'BackgroundColorChangedNotification'
  TextColorChangedNotification = 'TextColorChangedNotification'
  TwitterSearchQueryChangedNotification = 'TwitterSearchQueryChangedNotification'
  
  attr_accessor :backgroundColorWell, :textColorWell, :twitterSearchQueryTextField
  
  def self.registerUserDefaults
    defaults = {}
    defaults[BackgroundColorKey] = NSArchiver.archivedDataWithRootObject(NSColor.blackColor)
    defaults[TextColorKey] = NSArchiver.archivedDataWithRootObject(NSColor.whiteColor)
    defaults[TwitterSearchQueryKey] = '#MacRuby'
    NSUserDefaults.standardUserDefaults.registerDefaults(defaults)
  end
  registerUserDefaults
  
  def init
    if(!super.initWithWindowNibName("Preferences"))
      return nil
    else
      return self
    end
  end
  
  def windowDidLoad
    textColorWell.color = textColor
    backgroundColorWell.color = backgroundColor
    twitterSearchQueryTextField.stringValue = twitterSearchQuery
  end

  def textColor
    unarchiveColorForKey(TextColorKey)
  end

  def backgroundColor
    unarchiveColorForKey(BackgroundColorKey)
  end
  
  def twitterSearchQuery
    NSUserDefaults.standardUserDefaults.stringForKey(TwitterSearchQueryKey)
  end

  def changeBackgroundColor(sender)
    archiveColor(backgroundColorWell.color, BackgroundColorKey)
    postNotification(BackgroundColorChangedNotification)
  end

  def changeTextColor(sender)
    archiveColor(textColorWell.color, TextColorKey)
    postNotification(TextColorChangedNotification)
  end
  
  def changeTwitterSearchQuery(sender)
    NSUserDefaults.standardUserDefaults.setObject(twitterSearchQueryTextField.stringValue, forKey: TwitterSearchQueryKey)
    postNotification(TwitterSearchQueryChangedNotification)
  end

  private

  def unarchiveColorForKey(key)
    NSUnarchiver.unarchiveObjectWithData(
        NSUserDefaults.standardUserDefaults.dataForKey(key)
      )
  end

  def archiveColor(color,key)
    NSUserDefaults.standardUserDefaults.setObject(
        NSArchiver.archivedDataWithRootObject(color),
        forKey: key
      )    
  end

  def postNotification(key)
    NSNotificationCenter.defaultCenter.postNotificationName(
                                        key,
                                        object: self)
  end 
end