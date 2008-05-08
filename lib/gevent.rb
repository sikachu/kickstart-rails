# Class for storing the calendar event
class GEvent
  attr_reader :element, :title, :content, :start_date, :end_date, :edit_address, :calendar
  
  def initialize(calendar, element)
    @calendar = calendar
    @element = element
    
    # set name spaces for entry tag
    @element['xmlns'] = 'http://www.w3.org/2005/Atom'
    @element['xmlns:gCal'] = 'http://schemas.google.com/gCal/2005'
    @element['xmlns:gd'] = 'http://schemas.google.com/g/2005'
    
    @title = @element.at("title").inner_html
    @content = @element.at("content").inner_html
    @end_date = Date.parse(@element.at("gd:when")['startTime'])
    @start_date = Date.parse(@element.at("gd:when")['endTime'])
    @edit_address = @element.at("link[@rel=edit]")['href'].match(/google\.com(.*)$/)[1]
  end
  
  def title=(title)
    @title = title
    @element.at("title").inner_html = title
  end
  
  def content=(content)
    @content = content
    @element.at("content").inner_html = content
  end
  
  def to_xml
    @element.to_s
  end
  
  def to_s
    to_xml
  end
  
  def save!
    @calendar.gdata.do_request(edit_address, :xml => to_s, :method => :put)
    self
  end
  
end