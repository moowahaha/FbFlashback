require 'bundler'
Bundler.require

require './app'

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'assets/stylesheets'
  run environment
end

map '/' do
  run App
end
