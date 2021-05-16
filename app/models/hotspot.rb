class Hotspot < ApplicationRecord
  include BelongsToEvent

  def as_json(options = nil)
    {
      id: external_id,
      client: client_slug,
      event: event_slug,
      destination_url: destination_url
    }
  end
end
