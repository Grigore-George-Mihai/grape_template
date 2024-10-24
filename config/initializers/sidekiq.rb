sidekiq_config = { url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0") }

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config

  config.concurrency = 5
  config.queues = %w[critical default mailers]
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end
