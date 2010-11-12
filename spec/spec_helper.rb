require 'zmqp'
require 'pathname'

require 'bundler'
Bundler.setup
Bundler.require :test

BASE_PATH = Pathname.new(__FILE__).dirname + '..'

RSpec.configure do |config|
  # config.exclusion_filter = { :slow => true }
  # config.filter = { :focus => true }
  # config.include(UserExampleHelpers)
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
end

#$LOAD_PATH << "." unless $LOAD_PATH.include? "." # moronic 1.9.2 breaks things bad
#
#require 'rspec'
#require 'yaml'
#
#def rspec2?
#  defined?(RSpec)
#end

amqp_config = File.dirname(__FILE__) + '/amqp.yml'

if File.exists? amqp_config
  class Hash
    def symbolize_keys
      self.inject({}) { |result, (key, value)|
        new_key = key.is_a?(String) ? key.to_sym : key
        new_value = value.is_a?(Hash) ? value.symbolize_keys : value
        result[new_key] = new_value
        result
      }
    end
  end

  AMQP_OPTS = YAML::load_file(amqp_config).symbolize_keys[:test]
end
