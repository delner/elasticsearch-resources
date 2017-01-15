$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'simplecov'
require 'pry'
require 'rspec/collection_matchers'

# Start code coverage
SimpleCov.start

require "elasticsearch/resources"

# Load support files
Dir[File.join(File.expand_path('../../spec/support/', __FILE__), '**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
