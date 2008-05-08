require 'gevent'

# class which extends the formally GCalendar
class GCalendar
  attr_accessor :gdata
  
  def gdata=(gdata)
    @gdata = gdata
  end
  
  def address
    @address ||= self.url.match(/feeds\/((.+)\.google\.com)/)[1]
  end
  
  def set_available(date)
    event = list_events(date).first
    if event.nil?
      add_event "-- Available --", :start_date => date
    elsif event.title.match "-- Busy --"
      event.title = "-- Available --"
      event.save!
    else
      false
    end
  end
  
  def set_busy(date)
    event = list_events(date).first
    if event.nil?
      add_event "-- Busy --", :start_date => date
    elsif event.title.match "-- Available --"
      event.title = "-- Busy --"
      event.save!
    else
      false
    end
  end
  
  def add_event(title, data = {})
    # use our own method of sending request
    start_date = if data[:start_date].nil? then Date.today else data[:start_date] end
    end_date = if data[:end_date].nil? then start_date else data[:end_date] end
    content = if data[:content].nil? then "" else data[:content] end
    
    #prepare the xml request
    xml = @gdata.xml_builder
    xml.category :scheme => 'http://schemas.google.com/g/2005#kind', :term => 'http://schemas.google.com/g/2005#event'
    xml.title title, :type => :text
    xml.content content, :type => :text
    xml.gd :transparency, :value => "http://schemas.google.com/g/2005#event.opaque"
    xml.gd :eventStatus, :value => "http://schemas.google.com/g/2005#event.confirmed"
    xml.gd :when, :startTime => start_date.strftime('%Y-%m-%d'), :endTime => end_date.strftime('%Y-%m-%d')
    
    response = @gdata.do_request "/calendar/feeds/#{address}/private/full", :builder => xml
    
    # parse the returned data
    doc = Hpricot.XML(response.body)
    GEvent.new(self, (doc/:entry).first)
  end
  
  def remove_event(event)
    @gdata.do_request event.edit_address, :method => :delete
  end
  
  def remove_events_on(date)
    events = list_events(date)
    events.each do |e|
      remove_event e
    end
  end
  
  def list_events(start_date=nil, end_date=nil)
    # if start date and end date is nil, list the event for this week
    end_date = if end_date.nil? then \
      if start_date.nil? then Date.today.next_week else start_date + 1 end end
    start_date = Date.today.monday if start_date.nil?
    end_date += 1 if start_date.equal? end_date
 
    response = @gdata.do_request "/calendar/feeds/#{address}/private/full?" <<
        "start-min=#{start_date.strftime('%Y-%m-%dT00:00:00')}&" <<
        "start-max=#{end_date.strftime('%Y-%m-%dT00:00:00')}"
        
    # parse the returned data
    doc = Hpricot.XML(response.body)
    events = []
    (doc/:entry).each do |entry|
      events << GEvent.new(self, entry)
    end
    
    events
  end
  
end