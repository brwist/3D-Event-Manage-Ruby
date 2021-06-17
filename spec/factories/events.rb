# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id                       :bigint           not null, primary key
#  end_time                 :datetime
#  landing_background_color :string
#  landing_foreground_color :string
#  landing_logo             :string
#  landing_prompt           :string
#  name                     :string
#  slug                     :string
#  start_time               :datetime
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  client_id                :bigint           not null
#  main_entrance_id         :bigint
#
# Indexes
#
#  index_events_on_client_id         (client_id)
#  index_events_on_main_entrance_id  (main_entrance_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (main_entrance_id => rooms.id)
#
FactoryBot.define do
  factory :event do
    association(:client)
    association(:main_entrance, factory: :room)

    name { Faker::FunnyName.name }

    start_time { Time.zone.now + 5.days }
    end_time { start_time + 3.hours }
    landing_prompt { Faker::Lorem.words.join(' ') }
    landing_logo { Faker::Lorem.word }
    landing_background_color { Faker::Color.hex_color }
    landing_foreground_color { Faker::Color.hex_color }

    trait :with_attendees do
      after(:build) do |event|
        event.attendees << create_list(:attendee, 2, event: event)
      end
    end

    trait :with_hotspots do
      after(:build) do |event|
        event.hotspots << create_list(:hotspot, 2, event: event)
      end
    end

    trait :with_labels do
      after(:build) do |event|
        event.labels << create_list(:label, 2, event: event)
      end
    end
  end
end
