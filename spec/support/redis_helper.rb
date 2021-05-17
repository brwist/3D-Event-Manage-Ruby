# frozen_string_literal: true

module RedisHelper
  def clean_up_redis_tests
    keys_to_del = Redis.current.keys('test.*')
    Redis.current.del(keys_to_del) if keys_to_del.present?
  end

  def attendee_redis_data(event:, email: nil, attendee: nil)
    key = "test.attendee.#{event.client.slug}.#{event.slug}"
    redis_data = Redis.current.hget(key, email || attendee.email)
    Oj.load(redis_data) if redis_data
  end
end
