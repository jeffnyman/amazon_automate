require 'tapestry'
include Tapestry::Factory

require 'rspec'
include RSpec::Matchers
extend RSpec::Matchers

require "data_builder"
include DataBuilder

require 'test/unit/assertions'

require 'test_performance'

require 'awesome_print'

DataBuilder.load('product_data.yml')

Dir[File.dirname(__FILE__) + '/models/**/*.rb'].each { |file| load file }

def analyze_from(results)
  ap results.marshal_dump
end
