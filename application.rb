require 'sinatra'
require_relative 'environment'

configure do
  set :views, './views'
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
  profile = Profile.new(
    name: params[:name],
    surname: params[:surname],
    zip_code: params[:zip_code],
    city: params[:city],
    region: params[:region],
    address: params[:address],
    phone: params[:phone],
    email: params[:email],
    site: params[:site],
    photo_alliance: params[:photo_alliance],
    position: params[:position],
    skype: params[:skype],
    facebook: params[:facebook]
  )

  if profile.save
    session[:user_id] = profile.id.to_s
    return
  else
    status 406
    profile.errors.full_messages.join(', ')
  end
end

post '/upload' do
  profile = Profile.where(_id: session[:user_id]).first

  if !profile
    status 406
    return 'Не знайдено профіль'
  end

  position = 1
  5.times do |i|
    next unless params["image#{i}"]
    profile.photos << Photo.new(
      file:  params["image#{i}"],
      title: params["title#{i}"] || "фото #{i}",
      position: position
    )
    position += 1
  end

  if profile.photos.present? && profile.save
    session.delete(:user_id)
    profile.payment_url
  else
    status 406
    er_message = profile.errors.full_messages.join(', ')
    er_message || 'Перевірте розширення та розміри файлів'
  end
end

post '/payment/:id' do
  @profile = Profile.find(params[:id])
  if @profile.signature_valid?(params[:signature], params[:data])
    puts 'Money money money!!!'
    @profile.paid = true
    @profile.save
    @status = JSON.parse(Base64.decode64(params[:data]))['status']
    Pony.mail(
      from: SiteConfig.smtp_from,
      to: SiteConfig.smtp_to,
      subject: "Реєстрація #{@profile.name} #{@profile.surname}",
      html_body: haml(:email, layout: false),
      via: :smtp,
      via_options: {
        address:               SiteConfig.smtp_server,
        port:                  SiteConfig.smtp_port,
        enable_starttls_auto:  true,
        user_name:             SiteConfig.smtp_user_name,
        password:              SiteConfig.smtp_password,
        authentication:        :plain, # :plain, :login, :cram_md5, no auth by default
        domain:                SiteConfig.smtp_domain # the HELO domain provided by the client to the server
      }
    )

    Pony.mail(
      from: SiteConfig.smtp_from,
      to: @profile.email,
      subject: "Фотопортрет. Дякуємо за реєстрацію",
      html_body: haml(:email_for_user, layout: false),
      via: :smtp,
      via_options: {
        address:               SiteConfig.smtp_server,
        port:                  SiteConfig.smtp_port,
        enable_starttls_auto:  true,
        user_name:             SiteConfig.smtp_user_name,
        password:              SiteConfig.smtp_password,
        authentication:        :plain, # :plain, :login, :cram_md5, no auth by default
        domain:                SiteConfig.smtp_domain # the HELO domain provided by the client to the server
      }
    )
  end
end

get '/success' do
  haml :success
end
