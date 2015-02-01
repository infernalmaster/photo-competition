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
  Profile.get(session[:user_id]).try :destroy if session[:user_id]

  profile = Profile.new({
    name: params[:name],
    surname: params[:surname],
    city: params[:city],
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

  if !profile
    status 406
    return 'Не знайдено профіль'
  end

  profile.photos = []

  position = 1
  5.times do |i|
    next if !params["image#{i}"]
    profile.photos << Photo.new({
      file:  params["image#{i}"],
      title: params["title#{i}"] || "фото #{i}",
      position: position
    })
    position += 1
  end

  if profile.save(:with_photos)
    session.delete(:user_id)
    profile.payment_url
  else
    status 406
    er_message = profile.errors.values.join(', ')
    er_message || 'Перевірте розширення та розміри файлів'
  end

end

post "/payment/:id" do
  profile = Profile.get params[:id].to_i
  if profile.signature_valid?( params[:signature], params[:data] )
    profile.paid = true
    profile.save
    @status = JSON.decode( Base64.decode64( params[:data] ) )[:status]
    Pony.mail({
      to: 'you@example.com',
      html_body: ( haml :email ),
      via: :smtp,
      via_options: {
        address:               'smtp.gmail.com',
        port:                  '587',
        enable_starttls_auto:  true,
        user_name:             'user',
        password:              'password',
        authentication:        :plain, # :plain, :login, :cram_md5, no auth by default
        domain:                "localhost.localdomain" # the HELO domain provided by the client to the server
      }
    })
  end
end

get '/success' do
  haml :success
end
