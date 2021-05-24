# frozen_string_literal: true

class Token < ApplicationRecord
  belongs_to :room

  has_many :hotspots
  has_many :labels

  def create_url_hotspot(event:, url:, text:, type:, content: nil)
    hotspots.create!(event: event,
                     destination_url: url,
                     external_id: token,
                     type: type,
                     content: content,
                     mime_type: content&.file&.content_type)
    create_label(event: event, text: text)
  end

  def create_label(event:, text:)
    labels.create!(event: event, external_id: token, text: text)
  end

  def create_content_hotspot(event:, content:, text:)
    create_url_hotspot(event: event, url: content.file.key, text: text, type: :display, content: content)
  end
end
