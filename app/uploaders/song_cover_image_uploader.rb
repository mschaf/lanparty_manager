class SongCoverImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process convert: 'png'

  version :thumb do
    process resize_to_fill: [60, 60]
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def filename
    "cover.png" if original_filename
  end
end
