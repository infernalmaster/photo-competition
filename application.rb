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


post '/save_profile' do
  # todo do not create new if id exists
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
    profile.id.to_s
  else
    status 406
    profile.errors.values.join(', ')
  end

end

post '/upload/:id' do

  profile = Profile.get params[:id].to_i
  profile.photos = []

  5.times do |i|
    profile.photos << Photo.new({
      file:  params["image#{i}"],
      title: params["title#{i}"]
    })
  end

  if profile.save
    profile.payment_url
  else
    status 406
    photo.errors.values.join(', ')
  end

end



post "/payment/:id" do
  profile = Profile.get params[:id].to_i
  if profile.signature_valid?( params[:signature], params[:data] )
    profile.paid = true
    profile.save
  end
end
