require 'sinatra/base'

facebook do
  api_key '4579...cbb0'
  secret '5106...2342'
  app_id 81747826609
  url 'http://apps.facebook.com/myappname'
  callback 'http://myappserver.com'
end

get '/' do
  haml :index
end

get '/confirm' do
  fb.require_login!
  haml :confirm
end
