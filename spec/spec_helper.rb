require 'bundler'
Bundler.require :default, :test


require 'capybara'
require 'capybara/rspec'
require 'capybara/dsl'
require 'capybara-webkit'
require 'mockjax'

require File.expand_path('../app/app.rb', __FILE__)

Capybara.default_driver = :webkit
Capybara.app = Rack::Builder.new {
  use Rack::Mockjax
  run Sinatra::Application
}

RSpec.configure do |config|
  config.include Mockjax::Helpers
end
