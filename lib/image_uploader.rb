class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick
  storage :file

  def store_dir
    'uploads/images'
  end

  def extension_white_list
    %w(jpg jpeg gif png bmp)
  end

  version :thumb do
    process :resize_to_fill => [100,74]
  end

end