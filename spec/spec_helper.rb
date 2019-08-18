require 'rspec'
require 'rack/test'
require_relative '../server'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  
  def app
    PizzaPlanetServer
  end
end
