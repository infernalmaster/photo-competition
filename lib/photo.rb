class Photo
  include DataMapper::Resource
  property :id, Serial

  mount_uploader :file, ImageUploader
end