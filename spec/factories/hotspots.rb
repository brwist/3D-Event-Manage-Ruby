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
#  token_id        :bigint
#
# Indexes
#
#  index_hotspots_on_content_id  (content_id)
#  index_hotspots_on_event_id    (event_id)
#  index_hotspots_on_token_id    (token_id)
#
# Foreign Keys
#
#  fk_rails_...  (content_id => contents.id)
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (token_id => tokens.id)
#
FactoryBot.define do
  factory :hotspot do
    association(:event)
    destination_url { Faker::Internet.url(scheme: 'https') }
    type { 'redirect' }
    mime_type { 'application/pdf' }
    presign { false }

    after(:create) do |hotspot|
      hotspot.update!(external_id: hotspot.id.to_s)
    end
  end
end
