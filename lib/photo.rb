require 'image_uploader'
class Photo
  include DataMapper::Resource
  property :id,          Serial
  property :title,       String
  belongs_to :profile  # defaults to :required => true

  validates_presence_of :file

  mount_uploader :file, ImageUploader
end
