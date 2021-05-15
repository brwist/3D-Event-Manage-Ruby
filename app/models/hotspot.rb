class Hotspot < ApplicationRecord
  belongs_to :event

  delegate :client_slug, to: :event, prefix: false, allow_nil: true
  delegate :slug, to: :event, prefix: true, allow_nil: true

  def as_json(options = nil)
    {
      id: external_id,
      client: client_slug,
      event: event_slug,
      destination_url: destination_url
    }
  end
end
