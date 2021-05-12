module RedisHelper
  def clean_up_redis_tests
    keys_to_del = $redis.keys("test.*")
    $redis.del(keys_to_del) if keys_to_del.present?
  end

  def attendee_redis_data(email: nil, event:, attendee: nil)
    key = "test.attendee.#{event.client.slug}.#{event.slug}"
    redis_data = $redis.hget(key, email || attendee.email)
    Oj.load(redis_data) if redis_data
  end
end
