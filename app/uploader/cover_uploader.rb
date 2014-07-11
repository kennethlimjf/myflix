class CoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process :resize_to_fit => [664, 375]

  version :small do
    process :resize_to_fill => [166, 236]
  end

  def store_dir
    'uploads/cover'
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end