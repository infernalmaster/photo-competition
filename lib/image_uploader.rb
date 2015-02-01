require 'rmagick'

class ImageUploader < CarrierWave::Uploader::Base
  attr_reader :geometry

  #include CarrierWave::RMagick
  storage :file

  def store_dir
    'uploads/images'
  end

  def extension_white_list
    %w(jpg jpeg JPG JPEG)
  end
  process :get_geometry

  def get_geometry
    if (@file)
      img = ::Magick::Image::read(@file.file).first
      @geometry = { width: img.columns, height: img.rows }
    end
  end

  def filename
    "#{model.position}"+
    "_#{model.profile.name.to_slug.normalize(transliterations: [:ukrainian, :russian]).to_s}"+
    "_#{model.profile.surname.to_slug.normalize(transliterations: [:ukrainian, :russian]).to_s}"+
    "_#{model.title.to_slug.normalize(transliterations: [:ukrainian, :russian]).to_s}"+
    "_#{model.profile.address.to_slug.normalize(transliterations: [:ukrainian, :russian]).to_s}"+

    ".#{model.file.file.extension}"
  end

  #version :thumb do
  #  process :resize_to_fill => [100,74]
  #end

end
