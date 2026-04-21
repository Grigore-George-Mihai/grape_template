sidekiq_config = { url: ENV.fetch("REDIS_SIDEKIQ_URL", "redis://localhost:6379/1") }

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config

  config.concurrency = ENV.fetch("SIDEKIQ_CONCURRENCY", 5).to_i
  config.queues = %w[critical default mailers maintenance]
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end
