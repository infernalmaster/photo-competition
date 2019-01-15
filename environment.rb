require 'mongoid'
require 'haml'
require 'ostruct'
require 'carrierwave'
require 'carrierwave/mongoid'
# require 'rmagick'
require 'json'
require 'babosa'
require 'pony'

require 'sinatra' unless defined?(Sinatra)

require_relative 'settings.rb'

configure do
  SiteConfig = OpenStruct.new(SETTINGS)

  # load models
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/models")
  Dir.glob("#{File.dirname(__FILE__)}/models/*.rb") { |model| require File.basename(model, '.*') }

  Mongoid.load!("#{File.dirname(__FILE__)}/config/mongoid.yml")
end
