# frozen_string_literal: true
require 'connection_pool'

$redis = ConnectionPool::Wrapper.new(size: 10, timeout: 2) { Redis.new(url: ENV['REDIS_TLS_URL'], ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } ) }
