# frozen_string_literal: true

# == Schema Information
#
# Table name: labels
#
#  id          :bigint           not null, primary key
#  text        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  event_id    :bigint           not null
#  external_id :string
#  token_id    :bigint
#
# Indexes
#
#  index_labels_on_event_id                  (event_id)
#  index_labels_on_event_id_and_external_id  (event_id,external_id) UNIQUE
#  index_labels_on_token_id                  (token_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (token_id => tokens.id)
#
class Label < ApplicationRecord
  include BelongsToEvent

  belongs_to :token, optional: true

  validates :external_id, uniqueness: { scope: :event_id }

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
