# frozen_string_literal: true

class Token < ApplicationRecord
  belongs_to :room

  has_many :hotspots

  def create_url_hotspot(event:, url:)
    hotspots.create!(event: event, destination_url: url, external_id: token, type: 'redirect')
  end
end
