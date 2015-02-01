require 'image_uploader'
class Photo
  include DataMapper::Resource
  property :id,          Serial
  property :title,       String
  belongs_to :profile  # defaults to :required => true

  mount_uploader :file, ImageUploader

  validates_with_method :validate_minimum_image_size

  def validate_minimum_image_size
    geometry = self.image.geometry
    if (!geometry.empty?) && geometry.width > 2400 || geometry.height > 2400
      return true
    else
      [ false, "2400 px по довшій стороні мінімум" ]
    end
  end
end
