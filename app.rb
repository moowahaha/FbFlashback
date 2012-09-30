require 'sinatra/base'

class App < Sinatra::Base
  helpers do
    include Sinatra::Sprockets::Helpers
  end

  get '/' do
    haml :index
  end
end