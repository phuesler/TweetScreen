class NSUserDefaults
  def setColor(aColor, forKey:aKey)
      theData = NSArchiver.archivedDataWithRootObject(aColor)
      setObject(theData, forKey: aKey)
  end

  def colorForKey(aKey)
    theData= dataForKey(aKey)
    if theData
      NSUnarchiver.unarchiveObjectWithData(theData)
    else
      nil
    end
  end
end