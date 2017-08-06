# frozen_string_literal: true

# Respect current locale when sending background emails
require 'sidekiq/middleware/i18n'

if Rails.env.production?
  redis_url = 'localhost:6379'
  redis_timeout = 5

  Sidekiq.configure_server do |config|
    config.redis = { url: redis_url, network_timeout: redis_timeout }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: redis_url, network_timeout: redis_timeout }
  end
end
