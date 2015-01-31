class Photo
  include DataMapper::Resource
  property :id,          Serial
  property :title,       String
  belongs_to :profile  # defaults to :required => true

  mount_uploader :file, ImageUploader
end