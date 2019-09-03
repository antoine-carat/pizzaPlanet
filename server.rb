require 'sinatra'
require 'sinatra/cross_origin'
require 'json'
require_relative './db'

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
    File.read(File.join('public', 'index.html'))
  end

  get '/pizzas' do
    status 200
    DB.read('pizzas').to_json
  end

  post '/order' do
    params = JSON.parse(request.body.read) rescue nil
    if params.nil? || params.empty? || params["order"].nil? || params["order"]["items"].nil? || params["order"]["items"].nil?
      status 400
      'Order malformed'
    else
      status 201
      DB.create('orders', params)
      orders = DB.read('orders')
      { orderNumber: (orders.length - 1).to_s,
        order: orders.last }.to_json
    end
  end

  get '/order/:ordernumber' do
    orders = DB.read('orders')
    ordernumber = params[:ordernumber].to_i
    order = orders[ordernumber]
    if order.nil?
      status 404
      'Order Not Found'
    else
      status 200
      { orderNumber: ordernumber,
        order: order }.to_json
    end
  end
end
