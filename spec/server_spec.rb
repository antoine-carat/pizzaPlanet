require 'rspec'
require 'rack/test'

require_relative './spec_helper'
require_relative '../server'

RSpec.describe PizzaPlanetServer do
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
      before { get '/order/45332' }

      it 'should respond with code 200' do
        expect(last_response.status).to eq 200
      end

      it 'returns a hash containing an array of pizzas and a price' do
        expect(JSON.parse(last_response.body)).to be_a Hash
        expect(JSON.parse(last_response.body)['pizzas']).to be_an Array
        expect(JSON.parse(last_response.body)['total']).to be_a Number

      end
    end
  end
end
