# frozen_string_literal: true

# == Schema Information
#
# Table name: tokens
#
#  id          :bigint           not null, primary key
#  description :string
#  name        :string           not null
#  token       :string           not null
#  type        :string           default("content")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  room_id     :bigint           not null
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
  self.inheritance_column = nil
  enum type: { content: 'content', label: 'label', navigation: 'navigation' }

  belongs_to :room

  validates :name, :token, :type, presence: true

  def create_url_hotspot(event:, url:, text:, type:)
    create_hotspot(event: event, url: url, text: text, type: type)
  end

  def create_label(event:, text:)
    Label.create!(event: event, external_id: token, text: text)
  end

  def create_content_hotspot(event:, content:, text:)
    create_hotspot(event: event, url: content.file.key, text: text, type: :display, content: content)
  end

  def create_navigation_hotspot(event:, room:)
    create_hotspot(event: event, url: room.path, text: room.name, type: :navigation)
  end

  def hotspot(event_id:)
    Hotspot.find_by(event_id: event_id, external_id: token)
  end

  def label(event_id:)
    Label.find_by(event_id: event_id, external_id: token)
  end

  def detach_hotspot!(event_id:)
    hotspot(event_id: event_id)&.destroy!
    label(event_id: event_id)&.destroy!
  end

  private

  def create_hotspot(event:, text:, type:, content: nil, url: nil)
    label = create_label(event: event, text: text)
    Hotspot.create!(
      label: label,
      event: event,
      destination_url: url,
      external_id: token,    # NB: token.token
      type: type,
      content: content,
      mime_type: content&.file&.content_type,
      presign: content.present?
    )
  end
end
