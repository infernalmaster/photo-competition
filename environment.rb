require 'rubygems'
require 'bundler/setup'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-aggregates'
require 'dm-migrations'
require 'dm-constraints'
require 'haml'
require 'ostruct'
require 'carrierwave'
require 'carrierwave/datamapper'
require 'rmagick'
require 'json'
require 'babosa'

require 'sinatra' unless defined?(Sinatra)

configure do
  SiteConfig = OpenStruct.new(
                 :title => 'Your Application Name',
                 :author => 'Your Name',
                 :url_base => 'http://localhost:4567/'
               )

  # load models
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| require File.basename(lib, '.*') }

  DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite3:///#{File.expand_path(File.dirname(__FILE__))}/#{Sinatra::Base.environment}.db"))
  DataMapper.finalize #check models
  #DataMapper.auto_migrate! # drop and recreate all db tables
  #DataMapper.auto_upgrade!  # just add new columns and tables
end
