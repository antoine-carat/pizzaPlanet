require 'rspec'
require 'rack/test'

require_relative './spec_helper'
require_relative '../server'

RSpec.describe PizzaPlanetServer do
  before do
    allow(DB).to receive(:read)
      .with('pizzas')
      .and_return([
        { "name" => "Marguerita",
          "ingredients" => ["tomato", "mozarella", "basil"],
          "vegetarian" => true,
          "vegan" => false,
          "price" => 12.5 },
        { "name" => "Burger",
          "ingredients" => ["tomato", "cheddar", "pickels", "onions", "beef"],
          "vegetarian" => false,
          "vegan" => false,
          "price" => 14 },
        { "name" => "Gorlami",
          "ingredients" => ["tomato", "mozarella", "basil", "salami"],
          "vegetarian" => false,
          "vegan" => false,
          "price" => 13 },
        { "name" => "La French Compté",
          "ingredients" => ["tomato", "garlic", "compté", "baguette"],
          "vegetarian" => false,
          "vegan" => false,
          "price" => 13 }
      ])
  end

  describe 'GET /' do
    before { get '/' }

    it 'respond with code 200' do
      expect(last_response.status).to eq 200
    end
  end

  describe 'GET /pizzas' do
    before { get '/pizzas' }

    it 'should respond with code 200' do
      expect(last_response.status).to eq 200
    end

    it 'returns an Array of pizzas' do
      expect(JSON.parse(last_response.body)).to be_an Array
    end
  end

  describe 'POST /order' do
    context 'when the order is malformed' do
      it 'returns a 400 error if posted data is nil' do
        post('/order', nil)
        expect(last_response.status).to eq 400
      end

      it 'returns a 400 error if posted data is empty' do
        post('/order', {})
        expect(last_response.status).to eq 400
      end

      it 'returns a 400 error if posted data has no items or total is zero' do
        post('/order', {items: [], total: 0})
        expect(last_response.status).to eq 400
      end
    end

    context 'when the order form is good' do
      before { post('/order', { items: [], total: 0 }) }

      it 'responds with code 201 (Created)' do
        expect(last_response.status).to eq 201
      end

      it 'returns a order number' do
        expect(JSON.parse(last_response.body)['orderNumber']).to be_a String
      end

      it 'returns a hash containing an array of items and a price' do
        expect(JSON.parse(last_response.body)['order']).to be_a Hash
        expect(JSON.parse(last_response.body)['items']).to be_an Array
        expect(JSON.parse(last_response.body)['total']).to be_a Numeric
      end
    end
  end


  describe 'GET /order/:ordernumber' do
    context 'when the order is in DB' do
      before do
        allow(DB).to receive(:read)
          .with('orders')
          .and_return([{ "items" => { "La French Comté" => 1,
                                      "Gorlami" => 1 },
                         "total" => 26 }])
        get '/order/0'
      end

      it 'should respond with code 200' do
        expect(last_response.status).to eq 200
      end

      it 'returns a hash containing a hash of items and a price' do
        expect(JSON.parse(last_response.body)).to be_a Hash
        expect(JSON.parse(last_response.body)['orderNumber']).to be_a Numeric
        expect(JSON.parse(last_response.body)['order']['items']).to be_an Hash
        expect(JSON.parse(last_response.body)['order']['total']).to be_a Numeric
      end
    end

    context 'when the order is not in DB' do
      before do
        allow(DB).to receive(:read)
          .with('orders')
          .and_return([])
        get '/order/42345'
      end

      it 'should respond with 404 - Order Not Found' do
        expect(last_response.status).to eq 404
        expect(last_response.body).to eq('Order Not Found')
      end
    end
  end
end