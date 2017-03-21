require 'image_uploader'
class Photo
  include DataMapper::Resource
  property :id,          Serial
  property :title,       String
  property :position,    Integer
  belongs_to :profile  # defaults to :required => true

  validates_presence_of :file, :position

  mount_uploader :file, ImageUploader

  # validates_with_method :validate_minimum_image_size
  #
  # def validate_minimum_image_size
  #   geometry = self.file.geometry
  #   if (!geometry.empty?) && geometry[:width] >= 2400 || geometry[:height] >= 2400
  #     return true
  #   else
  #     return [ false, "2400 px по довшій стороні мінімум" ]
  #   end
  # end
end
