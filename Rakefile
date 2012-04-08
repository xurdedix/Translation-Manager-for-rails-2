require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('translation_manager', '0.1.0') do |p|
  p.description     = "helps you manage the locale yml files"
  p.url             = "http://github.com/XXXXXXXXXXXXXXXXXXXXXXX"
  p.author          = "Jorge Garcia"
  p.email           = "xurdedix@gmail.com"
  p.ignore_pattern  = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }