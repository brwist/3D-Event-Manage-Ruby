# frozen_string_literal: true

class Hotspot < ApplicationRecord
  self.inheritance_column = nil
  include BelongsToEvent

  def hotspots_key
    "hotspot.#{event_key}"
  end

  def as_json(_options = nil)
    {
      id: external_id,
      client: client_slug,
      event: event_slug,
      tooltip: tooltip,
      type: type,
      destination_url: destination_url
    }
  end

  def publish
    Redis.current.hset(hotspots_key, external_id, to_json)
  end
end
