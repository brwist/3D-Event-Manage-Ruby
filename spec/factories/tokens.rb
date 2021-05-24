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
FactoryBot.define do
  factory :token do
    association(:room)

    name { Faker::ChuckNorris.fact }
    token { Faker::Hipster.words.join('-') }
  end
end
