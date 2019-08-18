require 'rspec'
require 'rack/test'

require_relative './spec_helper'
require_relative '../server'

RSpec.describe PizzaPlanetServer do
  describe 'GET /' do
    before { get '/' }

    it 'returns Hello, world! (200)' do
      expect(last_response.status).to eq 200
      expect(last_response.body).to eq('Hello, world!')
    end
  end
end
