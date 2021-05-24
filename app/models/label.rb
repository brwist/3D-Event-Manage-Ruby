# frozen_string_literal: true

class Label < ApplicationRecord
  include BelongsToEvent

  belongs_to :token, optional: true

  def labels_key
    "label.#{event_key}"
  end

  def as_json(_options = nil)
    {
      id: external_id,
      client: client_slug,
      event: event_slug,
      text: text
    }
  end

  def publish
    Redis.current.hset(labels_key, external_id, to_json)
  end
end
