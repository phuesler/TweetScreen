class TwitterService
  TWITTER_SEARCH_URL = "http://twitter.com/search.json"
  attr_reader :delegate
  
  def initialize(query="Twitter", delegate)
    @query = query
    @delegate = delegate
    @refreshURL = nil
  end
  
  def refreshSearch
    @receivedData = nil
    if @currentConnection
      @currentConnection.cancel
    end
    request = NSURLRequest.requestWithURL(searchURL, cachePolicy: NSURLRequestReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60.0)
    @currentConnection = NSURLConnection.connectionWithRequest(request, delegate: self)
  end
  
  def searchURL
    if @refreshURL
      url = NSURL.URLWithString("#{TWITTER_SEARCH_URL}?#{@refreshURL}")
    else
      url = NSURL.URLWithString("#{TWITTER_SEARCH_URL}?q=#{@query}")
    end
  end
  
  def connectionDidFinishLoading(connection)
    response = parseJSON(@receivedData)
    self.delegate.newTweetsReceived(createTweets(response))
  end
  
  def connection(connection, didReceiveResponse: response)
    NSLog(response.statusCode.to_s)
  end
  
  def connection(connection, didReceiveData:data)
    @receivedData ||= NSMutableData.new
    @receivedData.appendData(data)
  end
  
  def connection(conn, didFailWithError:error)
    NSLog(error.localizedDescription)
  end
  
  def createTweets(response)
    (response['results'] || []).map do |status|
     image = NSImage.alloc.initWithContentsOfURL(NSURL.URLWithString(status['profile_image_url']))
     {image: image,  tweet: status["text"]}
    end
  end
  
  def parseJSON(data)
    JSON.parse(NSString.alloc.initWithData(data, encoding: NSUTF8StringEncoding))
  end
end