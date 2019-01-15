class Profile
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,      type:      String
  field :surname,   type:      String

  field :zip_code,  type:      String
  field :city,      type:      String
  field :region,    type:      String
  field :address,   type:      String
  field :phone,     type:      String
  field :email,     type:      String

  field :site,      type:      String
  field :photo_alliance, type: Boolean, default: false
  field :position,  type:      String
  field :skype,     type:      String
  field :facebook,  type:      String
  field :paid,      type:      Boolean, default: false

  has_many :photos

  validates_presence_of :name, :surname, :zip_code, :city, :address, :phone, :email

  def payment_url
    base = request_params

    "https://www.liqpay.com/api/checkout" +
      "?data=#{ URI::encode( base ) }" +
      "&signature=#{ URI::encode( signature( base ) ) }"
  end

  def signature_valid?(recieved_signature, recieved_data)
    signature(recieved_data) == recieved_signature
  end

  protected

    def rate
      if self.photo_alliance then 100 else 150 end
    end

    def request_params
      params = {
        version: 3,
        public_key: SiteConfig.pb_public_key,
        amount: rate,
        currency: 'UAH',
        description: "#{name.to_slug.normalize(transliterations: [:ukrainian, :russian]).to_s} #{self.surname.to_slug.normalize(transliterations: [:ukrainian, :russian]).to_s}",
        language: 'ru',
        order_id: order_id,
        server_url: "#{SiteConfig.url_base}/payment/#{id}",
        result_url: "#{SiteConfig.url_base}/success",
        sandbox: SiteConfig.sandbox
      }
      json = JSON.generate( params )
      Base64.encode64( json ).gsub("\n",'')
    end

    def order_id
      Time.now.to_s.parameterize + id.to_s
    end

    def signature(data)
      key = SiteConfig.pb_private_key + data + SiteConfig.pb_private_key
      key = Digest::SHA1.digest( key )
      Base64.encode64( key ).gsub("\n",'')
    end
end
