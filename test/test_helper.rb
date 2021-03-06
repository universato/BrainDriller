# [Qiita: SimpleCovとRails 6のMinitest](https://qiita.com/kazutosato/items/382afd90caf64b644e77)
# https://github.com/simplecov-ruby/simplecov/issues/718

unless ENV['CI']
  require 'simplecov'
  SimpleCov.start 'rails'
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  ## Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

  unless ENV['CI']
    parallelize_setup do |worker|
      SimpleCov.command_name "#{SimpleCov.command_name}-#{worker}"
    end

    parallelize_teardown do |worker|
      SimpleCov.result
    end
  end

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # include FactoryBot::Syntax::Methods
end
