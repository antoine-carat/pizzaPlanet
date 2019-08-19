require 'sinatra'
require 'sinatra/cross_origin'
require 'json'

# PizzaPlanetServer is awesome
class PizzaPlanetServer < Sinatra::Base
  set :bind, '0.0.0.0'

  configure do
    enable :cross_origin
  end

  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
  end

  get '/' do
    status 200
    # 'Hello, world!'
    File.read(File.join('public', 'index.html'))
  end

  get '/pizzas' do
    status 200
    db = JSON.parse(File.read('db.json'))
    db['pizzas'].to_json
  end
end
