CarrierWave.configure do |config|

  config.cache_dir = File.join(Rails.root, 'tmp', 'uploads')


  # WARNING: add the "carrierwave-aws" gem in your Rails app Gemfile.
  # More information here: https://github.com/sorentwo/carrierwave-aws

  if ENV['S3_KEY_ID'].present?
    puts "Debug: Loading with S3"
    config.storage          = :aws
    config.aws_bucket       = ENV['S3_BUCKET']
    config.aws_acl          = 'public-read'

    config.aws_credentials  = {
      access_key_id:      ENV['S3_KEY_ID'],
      secret_access_key:  ENV['S3_SECRET_KEY'],
      region:             ENV['S3_BUCKET_REGION']
    }

    config.aws_attributes = {
      expires: 1.week.from_now.httpdate,
      cache_control: 'max-age=604800'
    }

    # Put your CDN host below instead
    if ENV['S3_ASSET_HOST_URL'].present?
      puts "Debug: Loading with CloudFront"
      config.asset_host = ENV['S3_ASSET_HOST_URL']
    end
  else
    config.storage = :file
    config.root = File.join(Rails.root, 'public')
  end


  # case Rails.env.to_sym
  #
  # when :development
  #   config.storage = :file
  #   config.root = File.join(Rails.root, 'public')
  #
  # when :production
  #
  #
  # else
  #   # settings for the local filesystem
  #   config.storage = :file
  #   config.root = File.join(Rails.root, 'public')
  # end

end
