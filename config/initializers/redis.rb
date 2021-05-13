# frozen_string_literal: true

if Rails.env.test?
  Redis.current = MockRedis.new
else
  Redis.current = Redis.new(url: ENV['REDIS_TLS_URL'], ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } )
end
