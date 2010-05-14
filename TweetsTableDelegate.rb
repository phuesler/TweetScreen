class TweetsTableDelegate
  attr_accessor :tableView
  
  def tweets
    @tweets ||= []
  end
  
  def tweets=(new_tweets)
    @tweets = new_tweets
    tableView.reloadData
  end
  
  def numberOfRowsInTableView(tableView)
    tweets.size
  end
  
  def tableView(tableView, objectValueForTableColumn: column, row: row)
    tweets[row].valueForKey(column.identifier.to_sym)
  end
end
