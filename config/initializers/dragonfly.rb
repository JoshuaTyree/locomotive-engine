# Configure
Dragonfly.app(:engine).configure do
  plugin :imagemagick,
    convert_command:  `which convert`.strip.presence || '/usr/local/bin/convert',
    identify_command: `which identify`.strip.presence || '/usr/local/bin/identify'

  verify_urls true

  secret '426c95ac2405899a4d20b2b462b748ee16a04f428c2b80d51a81d76be55a42b6'

  url_format '/images/dynamic/:job/:sha/:basename.:ext'

  if ENV['S3_ASSET_HOST_URL'].present? && !ENV['S3_ASSET_HOST_URL'].blank?
    url_host ENV['S3_ASSET_HOST_URL']
  end

  fetch_file_whitelist /public/

  fetch_url_whitelist /.+/
end

Dragonfly.app(:steam).configure do
  if ENV['S3_ASSET_HOST_URL'].present? && !ENV['S3_ASSET_HOST_URL'].blank?
    url_host ENV['S3_ASSET_HOST_URL']
  end
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware, :engine
