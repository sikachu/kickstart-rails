require 'rubygems'
require 'googlecalendar'
require 'hpricot'
require 'builder'
require 'gevent'
require 'gcalendar'

class GDataExtension < GData
  # override the find_calendar method
  def find_calendar(x)
    get_calendars if @calendars.empty?
    calendar = @calendars.find {|c| c.title.match x}
    calendar.gdata = self
    calendar
  end
  
  def create_calendar(title, summary = "")
    xml = xml_builder
    xml.title title, :type => "text"
    xml.summary summary, :type => "text"
    xml.gCal :timezone, :value => "Asia/Bangkok"
    xml.gCal :hidden, :value => :false
    xml.gCal :selected, :value => :true
    
    response = do_request "/calendar/feeds/default/owncalendars/full", :builder => xml
    unless response = Net::HTTPSuccess
      calendar = GCalendar.new(title, summary)
      calendar.gdata = self
      calendar
    end
  end
  
  def remove_calendar(title)
    calendar = find_calendar(title)
    
    if calendar
      do_request "/calendar/feeds/default/owncalendars/full/#{calendar.address}", :method => :delete
    else
      raise "Calendar not found"
    end
  end
    
  def do_request(path, data={})
    data[:method] ||= if data[:xml] || data[:builder] then :post else :get end
    data[:xml] ||= get_xml(data[:builder]) if data[:method] == :post or data[:method] == :put
    #puts path
    
    #make a connection
    http = Net::HTTP.new(@google_url, 80)
    
    response = _connect(http, data[:method], path, data[:xml])
    #puts calendar.url
  
    case response
    when Net::HTTPSuccess, Net::HTTPRedirection
      redirect_response = _connect(http, data[:method], response['location'], data[:xml])
      case response
      when Net::HTTPSuccess, Net::HTTPRedirection
        return redirect_response
      else
        response.error!
      end
    else
      response.error!
    end
  end
  
  def xml_builder
    Builder::XmlMarkup.new
  end
  
  def get_xml(content_builder)
    x = xml_builder
    x.instruct!
    x.entry(:xmlns => 'http://www.w3.org/2005/Atom', :"xmlns:gd" => 'http://schemas.google.com/g/2005', :"xmlns:gCal" => 'http://schemas.google.com/gCal/2005') do
      x << content_builder.target!
    end
    
    x.target!
  end
  
  protected
  
  def _connect(http, method, url, content=nil)
    case method
    when :get
      http.get(url, @headers)
    when :post
      http.post(url, content, @headers)
    when :put
      http.put(url, content, @headers)
    when :delete
      http.delete(url, @headers)
    else
      raise "Unsupport HTTP method"
    end
  end
  
end