# frozen_string_literal: true

# == Schema Information
#
# Table name: tokens
#
#  id         :bigint           not null, primary key
#  content    :boolean          default(FALSE)
#  name       :string           not null
#  token      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  room_id    :bigint           not null
#
# Indexes
#
#  index_tokens_on_room_id  (room_id)
#
# Foreign Keys
#
#  fk_rails_...  (room_id => rooms.id)
#
class Token < ApplicationRecord
  belongs_to :room

  has_many :hotspots
  has_many :labels

  def create_url_hotspot(event:, url:, text:, type:)
    create_hotspot(event: event, url: url, text: text, type: type)
  end

  def create_label(event:, text:)
    labels.create!(event: event, external_id: token, text: text)
  end

  def create_content_hotspot(event:, content:, text:)
    create_hotspot(event: event, url: content.file.key, text: text, type: :display, content: content)
  end

  def hotspot(event_id:)
    hotspots.select { |h| h.event_id == event_id }.first
  end

  def label(event_id:)
    labels.select { |h| h.event_id == event_id }.first
  end

  private

  def create_hotspot(event:, text:, type:, content: nil, url: nil)
    create_label(event: event, text: text)
    hotspots.create!(
      event: event,
      destination_url: url,
      external_id: token, # -> token.token
      type: type,
      content: content,
      mime_type: content&.file&.content_type,
      presign: content.present?
    )
  end
end
