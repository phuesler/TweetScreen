require 'json'

class TwitterService
  TWITTER_SEARCH_URL = "http://twitter.com/search.json"
  attr_reader :delegate, :refreshURL
  
  def initialize(query="Twitter", options = {delegate: nil, refreshInterval: 30})
    @query = query
    @cancel = false
    @delegate = options[:delegate]
    @refreshURL = nil
    @timer = NSTimer.scheduledTimerWithTimeInterval(options[:refreshInterval],
                                                    target: self,
                                                    selector: :refreshSearch,
                                                    userInfo: nil,
                                                    repeats: true)
  end
  
  def cancelled?
    @cancel
  end
  
  def cancel!
    NSLog("cancelling")
    cancelConnection
  end
  
  def refreshSearch
    return if cancelled?
    @receivedData = nil
    request = NSURLRequest.requestWithURL(searchURL, cachePolicy: NSURLRequestReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20.0)
    @currentConnection = NSURLConnection.connectionWithRequest(request, delegate: self)
    NSLog("Connecting to: #{searchURL.absoluteString}")
  end
    
  def searchURL
    if refreshURL
      NSURL.URLWithString("#{TWITTER_SEARCH_URL}#{refreshURL}")
    else
      NSURL.URLWithString("#{TWITTER_SEARCH_URL}?q=#{escapeString(@query)}")
    end
  end
  
  def connectionDidFinishLoading(connection)
    unless cancelled?
      response = parseJSON(@receivedData)
      @refreshURL = response['refresh_url']
      self.delegate.newTweetsReceived(createTweets(response))
    end
  end
  
  def connection(connection, didReceiveResponse: response)
  end
  
  def connection(connection, didReceiveData:data)
    @receivedData ||= NSMutableData.new
    @receivedData.appendData(data)
  end
  
  def connection(conn, didFailWithError:error)
    NSLog(error.localizedDescription)
  end
  
  protected
  
  def createTweets(response)
    (response['results'] || []).map do |status|
     image = NSImage.alloc.initWithContentsOfURL(NSURL.URLWithString(status['profile_image_url']))
     {image: image,  tweet: status["text"]}
    end
  end
  
  def parseJSON(data)
    JSON.parse(NSString.alloc.initWithData(data, encoding: NSUTF8StringEncoding))
  end
  
  def escapeString(string)
    string.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
  end
  
  def cancelConnection
    @cancel = true
    @timer.invalidate
    unless @currentConnection.nil?
      @currentConnection.cancel
      @currentConnection = nil
    end
  end
end