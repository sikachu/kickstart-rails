Haml::Template::options[:format] = :html4

if RAILS_ENV == 'production'
  Sass::Plugin::options[:style] = :compact
  Haml::Template::options[:ugly] = true
end
