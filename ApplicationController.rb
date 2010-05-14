require 'json'

class ApplicationController
  attr_accessor :tweetsTableView
  
  def applicationDidFinishLaunching(notification)
    NSLog("yeah")
    url = NSURL.URLWithString("http://twitter.com/statuses/public_timeline.json")
    request = NSURLRequest.requestWithURL(url)
    NSURLConnection.connectionWithRequest(request, delegate: self)
  end
  
  def timeline
    @timeline ||= []
  end
  
  def connectionDidFinishLoading(connection)
    NSLog("finished loading")
    responseString = NSString.alloc.initWithData(@receivedData, encoding: NSUTF8StringEncoding)
    statuses = JSON.parse(responseString)
    statuses.each do |status|
     image = NSImage.alloc.initWithContentsOfURL(NSURL.URLWithString(status['user']['profile_image_url']))
     @timeline.push({image: image,  tweet: status["text"]})
    end
    self.tweetsTableView.reloadData
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
  end
  
  def numberOfRowsInTableView(tableView)
    timeline.size
  end
  
  def tableView(tableView, objectValueForTableColumn: column, row: row)
    return timeline[row].valueForKey(column.identifier.to_sym)
  end
end