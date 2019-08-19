require 'rspec'
require 'rack/test'

require_relative './spec_helper'
require_relative '../server'

RSpec.describe PizzaPlanetServer do
  before do
    allow(File).to receive(:read)
      .with('db.json')
      .and_return('{
        "orders": {
          "1": {
            "items": [],
            "total": 0
          }
        },
        "pizzas": [
          {
            "name": "Marguerita",
            "ingredients": ["tomato", "mozarella", "basil"],
            "vegetarian": true,
            "vegan": false,
            "price": 12.5
          },
          {
            "name": "Burger",
            "ingredients": ["tomato", "cheddar", "pickels", "onions", "beef"],
            "vegetarian": false,
            "vegan": false,
            "price": 14
          },
          {
            "name": "Gorlami",
            "ingredients": ["tomato", "mozarella", "basil", "salami"],
            "vegetarian": false,
            "vegan": false,
            "price": 13
          },
          {
            "name": "La French Compté",
            "ingredients": ["tomato", "garlic", "compté", "baguette"],
            "vegetarian": false,
            "vegan": false,
            "price": 13
          }
        ]
      }')
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

  describe 'GET /order/:ordernumber' do
    context 'when the order is in DB' do
      before { get '/order/1' }

      it 'should respond with code 200' do
        expect(last_response.status).to eq 200
      end

      it 'returns a hash containing an array of items and a price' do
        expect(JSON.parse(last_response.body)).to be_a Hash
        expect(JSON.parse(last_response.body)['items']).to be_an Array
        expect(JSON.parse(last_response.body)['total']).to be_a Numeric
      end
    end

    context 'when the order is not in DB' do
      before { get '/order/42345' }

      it 'should respond with 404 - Order Not Found' do
        expect(last_response.status).to eq 404
        expect(last_response.body).to eq('Order Not Found')
      end
    end
  end
end
