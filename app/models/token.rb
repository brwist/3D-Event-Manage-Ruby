# frozen_string_literal: true

class Token < ApplicationRecord
  belongs_to :room

  has_many :hotspots
  has_many :labels

  def create_url_hotspot(event:, url:, text:)
    hotspots.create!(event: event, destination_url: url, external_id: token, type: 'redirect')
    create_label(event: event, text: text)
  end

  def create_label(event:, text:)
    labels.create!(event: event, external_id: token, text: text)
  end
end
