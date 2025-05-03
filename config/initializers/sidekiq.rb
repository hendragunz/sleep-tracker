Sidekiq.configure_server do |config|
  config.redis_options = { url: "redis://localhost:6379/0" }
end
