module BelongsToEvent
  extend ActiveSupport::Concern

  included do
    belongs_to :event

    delegate :client_slug, to: :event, prefix: false, allow_nil: true
    delegate :slug, to: :event, prefix: true, allow_nil: true

    def event_key
      "#{client_slug}.#{event_slug}"
    end
  end
end
