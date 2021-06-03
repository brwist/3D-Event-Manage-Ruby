# frozen_string_literal: true

# == Schema Information
#
# Table name: hotspots
#
#  id              :bigint           not null, primary key
#  destination_url :string
#  mime_type       :string
#  presign         :boolean          default(FALSE)
#  type            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  content_id      :bigint
#  event_id        :bigint           not null
#  external_id     :string
#  label_id        :bigint
#
# Indexes
#
#  index_hotspots_on_content_id                (content_id)
#  index_hotspots_on_event_id                  (event_id)
#  index_hotspots_on_event_id_and_external_id  (event_id,external_id) UNIQUE
#  index_hotspots_on_label_id                  (label_id)
#
# Foreign Keys
#
#  fk_rails_...  (content_id => contents.id)
#  fk_rails_...  (event_id => events.id)
#
class Hotspot < ApplicationRecord
  self.inheritance_column = nil
  include BelongsToEvent

  enum type: {
    redirect: 'redirect',
    new_page: 'new_page',
    display: 'display',
    navigation: 'navigation'
  }

  belongs_to :label, optional: true, dependent: :destroy
  belongs_to :content, optional: true

  validates :external_id, uniqueness: { scope: :event_id }

  def hotspots_key
    "hotspot.#{event_key}"
  end

  def as_json(_options = nil)
    {
      id: external_id,
      client: client_slug,
      event: event_slug,
      type: type,
      mime_type: mime_type,
      presign: presign,
      destination_url: destination_url
    }
  end

  def publish
    Redis.current.hset(hotspots_key, external_id, to_json)
  end
end
