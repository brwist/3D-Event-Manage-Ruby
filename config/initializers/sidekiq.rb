# frozen_string_literal: true
require 'connection_pool'

REDIS_POOL = ConnectionPool.new(size: 10) { Redis.new(url: ENV['REDIS_URL']) }

Sidekiq.configure_server do |config|
  config.options = config.options.merge(queues: %w( default active_storage_analysis ), concurrency: ENV.fetch("WORKER_MAX_THREADS") { 5 })
  config.default_worker_options = config.default_worker_options.merge(retry: false)
  config.redis = REDIS_POOL
end if defined?(Sidekiq)

Sidekiq.configure_client do |config|
  config.default_worker_options = config.default_worker_options.merge(retry: false)
  config.redis = REDIS_POOL
end if defined?(Sidekiq)
