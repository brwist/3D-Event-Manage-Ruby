# frozen_string_literal: true

Redis.current = if Rails.env.test?
                  MockRedis.new
                else
                  Redis.new(url: ENV['REDIS_TLS_URL'], ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
                end
