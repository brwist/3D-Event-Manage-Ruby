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
FactoryBot.define do
  factory :label do
    association(:event)
    text { Faker::Lorem.words.join(' ') }

    after(:create) do |label|
      label.update!(external_id: "a#{label.id}")
    end
  end
end
