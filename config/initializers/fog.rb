# CarrierWave.configure do |config|
#   config.fog_credentials = {
#     :provider               => 'AWS',
#     :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
#     :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
#     :region                 => 'us-east-1'
#   }
#   config.fog_directory  = 'charitymap'
#   config.fog_public     = false
#   config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
# end

CarrierWave.configure do |config|
  config.storage    = :aws
  config.aws_bucket = (Rails.env.production? ? 'charitymap' : 'charitymap-dev')
  config.aws_acl    = :public_read
  # config.asset_host = 'http://example.com'
  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365

  config.aws_credentials = {
    access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  }
end