# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    association(:client)
    association(:main_entrance, factory: :experience)

    name { Faker::FunnyName.name }

    start_time { Time.zone.now + 5.days }
    end_time { start_time + 3.hours }

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
