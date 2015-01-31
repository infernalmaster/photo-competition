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

enable :sessions

# root page
get '/' do
  haml :root
end


post '/save_profile' do
  Profile.get(session[:user_id]).destroy if session[:user_id]

  profile = Profile.new({
    name: params[:name],
    surname: params[:surname],
    address: params[:address],
    phone: params[:phone],
    email: params[:email],
    site: params[:site],
    photo_alliance: params[:photo_alliance],
    position: params[:position]
  })

  if profile.save
    session[:user_id] = profile.id.to_i
    return
  else
    status 406
    profile.errors.values.join(', ')
  end

end

post '/upload' do

  profile = Profile.get session[:user_id]
  profile.photos = []

  5.times do |i|
    profile.photos << Photo.new({
      file:  params["image#{i}"],
      title: params["title#{i}"]
    })
  end

  # todo коли при валідації зображень станеться помилка то профіль всервно збережеться
  # тому потрібно це десь врахувати
  if profile.save
    session.delete(:user_id)
    redirect profile.payment_url
  else
    status 406
    profile.errors.values.join(', ')
  end

end



post "/payment/:id" do
  profile = Profile.get params[:id].to_i
  if profile.signature_valid?( params[:signature], params[:data] )
    profile.paid = true
    profile.save
  end
end
