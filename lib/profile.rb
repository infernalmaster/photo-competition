# example model file
class Profile
  include DataMapper::Resource

  property :id,             Serial
  property :name,           String
  property :surname,        String

  property :zip_code,       String
  property :city,           String
  property :address,        String
  property :phone,          String
  property :email,          String

  property :site,           String
  property :photo_alliance, Boolean, default: false
  property :position,       String
  property :paid,           Boolean, default: false

  property :created_at,     DateTime
  property :updated_at,     DateTime

  has n, :photos
  validates_presence_of :photos, when: [ :with_photos ]

  validates_presence_of :name, :surname, :zip_code, :city, :address, :phone, :email

  def payment_url
    base = request_params

    "https://www.liqpay.com/api/checkout" +
      "?data=#{ URI::encode( base ) }" +
      "&signature=#{ URI::encode( signature( base ) ) }"
  end

  protected

    def rate
      if self.photo_alliance then 70 else 120 end
    end

    def request_params
      params = {
        version: 3,
        public_key: SiteConfig.pb_public_key,
        amount: rate,
        currency: 'UAH',
        description: self.id,
        language: 'ru',
        order_id: order_id,
        server_url: "#{SiteConfig.url_base}/payment/#{self.id}",
        result_url: SiteConfig.url_base,
        sandbox: 1
      }
      json = JSON.generate( params )
      Base64.encode64( json ).gsub("\n",'')
    end

    def order_id
      Time.now.to_s.parameterize + self.id.to_s
    end

    def signature_valid?(recieved_signature, recieved_data)
      signature(recieved_data) == recieved_signature
    end

    def signature(data)
      key = SiteConfig.pb_private_key + data + SiteConfig.pb_private_key
      key = Digest::SHA1.digest( key )
      Base64.encode64( key ).gsub("\n",'')
    end
end
