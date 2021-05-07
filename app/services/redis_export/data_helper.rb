module RedisExport
  module DataHelper
    def event_key
      if Rails.env.test?
        "test.attendee.#{@client.slug}.#{@event.slug}"
      else
        "attendee.#{@client.slug}.#{@event.slug}"
      end
    end

    def attendee_json
      # NB: Use mode: :compat option for symbol keys
      Oj.dump(
        'client' => @client.name,
        'event'  => @event.name,
        'name'   => @attendee.name,
        'email'  => @attendee.email,
        'encrypted_password' => @attendee.encrypted_password
      )
    end
  end
end
