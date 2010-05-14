class TweetsView < NSView
  KEY_CODE_ESC = 53
  
  def keyDown(theEvent)
    if theEvent.modifierFlags & NSNumericPadKeyMask
      exitFullScreenModeWithOptions(nil) if theEvent.keyCode == KEY_CODE_ESC && isInFullScreenMode
      self.interpretKeyEvents([theEvent])
    else
      super.keyDown(theEvent)
    end
  end
end
