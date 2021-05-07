# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    association(:client)

    name { "Fun on the background of bare rock" }
    start_time { Time.zone.now + 5.days }
    end_time { start_time + 3.hours }
  end
end
