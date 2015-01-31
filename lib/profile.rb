# example model file
class Profile
  include DataMapper::Resource

  property :id,             Serial
  property :name,           String
  property :surname,        String
  property :address,         String
  property :phone,          String
  property :email,          String

  property :site,           String
  property :photo_alliance, String
  property :position,       String
  property :paid,           Boolean, default: false

  property :created_at,     DateTime
  property :updated_at,     DateTime

  validates_presence_of :name, :surname, :adress, :phone, :email

  def payment_url
    base = request_params

    "https://www.liqpay.com/api/checkout" +
      "?data=#{ URI::encode( base ) }" +
      "&signature=#{ URI::encode( signature( base ) ) }"
  end

  protected

    def rate
      650
    end

    def request_params
      params = {
        version: 3,
        public_key: 'public_key',
        amount: rate,
        currency: 'UAH',
        description: self.id,
        language: 'ru',
        order_id: order_id,
        server_url: "http://localhost:4567/payment/#{self.id}",
        result_url: "http://localhost:4567",
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
      key = 'private_key' + data + 'private_key'
      key = Digest::SHA1.digest( key )
      Base64.encode64( key ).gsub("\n",'')
    end
end
