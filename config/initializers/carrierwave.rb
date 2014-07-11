require 'fog/aws/storage'
require 'carrierwave'

CarrierWave.configure do |config|

  if Rails.env.staging? || Rails.env.production?
    config.storage :fog
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['S3_KEY'],
      :aws_secret_access_key  => ENV['S3_SECRET'],
      :region                 => 'ap-southeast-1',
      :host                   => Rails.env.production? ? 'movix.herokuapp.com' : 'movix-staging.herokuapp.com'
    }
    config.fog_directory  = ENV['S3_BUCKET_NAME']
  elsif Rails.env.development?
    config.storage :fog
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['S3_KEY'],
      :aws_secret_access_key  => ENV['S3_SECRET'],
      :region                 => 'ap-southeast-1'
    }
    config.fog_directory  = ENV['S3_BUCKET_NAME']
    config.enable_processing = true
  else
    config.storage :file
    config.enable_processing = false
  end
end