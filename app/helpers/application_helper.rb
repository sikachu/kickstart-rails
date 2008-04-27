begin
  require 'rubypants'
rescue LoadError
  RAILS_DEFAULT_LOGGER.warn "Couldn't load RubyPants (gem install rubypants)"
end

module ApplicationHelper
  
  def home?
    request.path == home_path
  end

  def active_link_to(text, path, exact = false)
    active = ( exact ? request.path == path : (request.path+'/').index(path+'/') == 0 ) && 'current'
    link_to text, path, :class => active
  end

  def unless_on(name)
    path = send("#{name}_path")
    yield(path) unless request.path == path
  end
  
  # useful for stuff like dates
  def nobreak(text)
    text.to_s.gsub(/ +/, '&nbsp;')
  end

  # http://shauninman.com/archive/2006/08/22/widont_wordpress_plugin
  def widont(text)
    text.strip!
    text[text.rindex(' '), 1] = '&nbsp;' if text.rindex(' ')
    text
  end

  # http://daringfireball.net/projects/smartypants/
  def smartypants(text)
    return text unless defined? RubyPants
    text.blank? ? '' : RubyPants.new(text).to_html
  end

end
