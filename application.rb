require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require File.join(File.dirname(__FILE__), 'environment')

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
end

error do
  e = request.env['sinatra.error']
  Kernel.puts e.backtrace.join("\n")
  'Application error'
end

helpers do
  # add your helpers here
end

# root page
get '/' do
  @photos = Photo.all
  @profile = Profile.first
  haml :root
end

post '/submit' do
  profile = Profile.new
  profile.name = params[:name]
  profile.surname = params[:surname]
  profile.address = params[:address]
  profile.phone = params[:phone]
  profile.email = params[:email]
  profile.site = params[:site]
  profile.photo_alliance = params[:photo_alliance]
  profile.position = params[:position]

  if profile.save

    redirect profile.payment_url
  end

end

post "/payment/:id" do
  profile = Profile.get(params[:id])
  if profile.signature_valid?( params[:signature], params[:data] )
    profile.paid = true
    profile.save
  end
end

post '/upload' do
  upload = Photo.new
  upload.file = params[:image]
  upload.save
  redirect "/", 303
end
