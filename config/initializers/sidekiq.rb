# frozen_string_literal: true
#require 'connection_pool'
#
#$redis = ConnectionPool::Wrapper.new(size: 10, timeout: 2) { Redis.new(url: ENV['REDIS_TLS_URL'], ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } ) }
#
#Sidekiq.configure_server do |config|
#  config.options = config.options.merge(queues: %w( default active_storage_analysis ), concurrency: ENV.fetch("WORKER_MAX_THREADS") { 5 })
#  config.default_worker_options = config.default_worker_options.merge(retry: false)
#  config.redis = $redis
#end if defined?(Sidekiq)
#
#Sidekiq.configure_client do |config|
#  config.default_worker_options = config.default_worker_options.merge(retry: false)
#  config.redis = $redis
#end if defined?(Sidekiq)
