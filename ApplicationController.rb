require 'json'

class ApplicationController
  YES = true
  NO = false
  
  attr_accessor :tweetsTableView, :reload
  
  def init
    if !super
      return nil
    else
      @refresh_url = nil
      @timeline = []
      return self
    end
  end
  
  def applicationDidFinishLaunching(notification)
    NSLog("yeah")
    refreshTweets
    @timer = NSTimer.scheduledTimerWithTimeInterval(30,
                                                    target: self,
                                                    selector: :refreshTweets,
                                                    userInfo: nil,
                                                    repeats: YES)
  end
  
  def connectionDidFinishLoading(connection)
    NSLog("finished loading")
    responseString = NSString.alloc.initWithData(@receivedData, encoding: NSUTF8StringEncoding)
    statuses = JSON.parse(responseString)
    @receivedData = nil
    @timeline = []
    statuses['results'].each do |status|
     image = NSImage.alloc.initWithContentsOfURL(NSURL.URLWithString(status['profile_image_url']))
     @timeline << {image: image,  tweet: status["text"]}
    end
    @refresh_url = statuses['refresh_url']
    NSLog(statuses['results'].first["text"])
    self.tweetsTableView.reloadData
  end
  
  def refreshTweets
    if @refresh_url
      url = NSURL.URLWithString("http://twitter.com/search.json?#{@refresh_url}")
    else
      url = NSURL.URLWithString("http://twitter.com/search.json?q=%23Telegraaf")
    end

    request = NSURLRequest.requestWithURL(url, cachePolicy: NSURLRequestReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60.0)
    NSURLConnection.connectionWithRequest(request, delegate: self)
  end
  
  def connection(connection, didReceiveResponse: response)
    NSLog("received response")
    NSLog(response.statusCode.to_s)
  end
  
  def connection(connection, didReceiveData:data)
    NSLog("received data")
    @receivedData ||= NSMutableData.new
    @receivedData.appendData(data)
  end
  
  def connection(conn, didFailWithError:error)
    NSLog("FAILED")
    NSLog(error.localizedDescription)
  end
  
  def reload(sender)
    refreshTweets
  end
  
  def numberOfRowsInTableView(tableView)
    @timeline.size
  end
  
  def tableView(tableView, objectValueForTableColumn: column, row: row)
    return @timeline[row].valueForKey(column.identifier.to_sym)
  end
  
  def applicationShouldTerminate(sender)
    @timer.invalidate
    return NSTerminateNow
  end
end