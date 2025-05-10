require "ostruct"
require "sidekiq-unique-jobs"

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://localhost:6379/8" }

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end

  config.server_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Server
  end
end


Sidekiq.configure_client do |config|
  config.redis = { url: "redis://localhost:6379/8" }

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end
end
