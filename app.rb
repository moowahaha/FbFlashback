require 'sinatra/base'
require 'sinatra/contrib'

include Koala

enable :sessions

get '/' do
  haml :index
end

get '/callback' do
  session['access_token'] = session['oauth'].get_access_token(params[:code])
  redirect '/slideshow'
end

get '/login' do
  session['oauth'] = Facebook::OAuth.new(
      ENV['FB_APP_ID'],
      ENV['FB_APP_SECRET'],
      "http://#{request.host_with_port}/callback"
  )

  redirect session['oauth'].url_for_oauth_code(permissions: 'user_photos friends_photos')
end

get '/slideshow' do
  login!

  haml :slideshow
end

get '/photos' do
  photos = []
  albums = []

  graph = Koala::Facebook::API.new(session['access_token'])

  graph.batch do |batch|
    batch.get_connections('me', 'photos', limit: 1000) do |result|
      result.sample(50).each do |photo|
        photos << photo['images'].first['source']
      end
    end

    batch.get_connections('me', 'albums', limit: 1000) do |result|
      result.sample(100).each do |album|
        albums << album
      end
    end
  end

  graph.batch do |batch|
    albums.each do |album|
      batch.get_connections(album['id'], 'photos', limit: 1000) do |nested_result|
        nested_result.sample(6).each do |photo|
          photos << photo['images'].first['source']
        end
      end
    end
  end

  json photos.flatten.uniq.shuffle[0...199]
end

def login!
  redirect '/login' if !session['access_token']
end
