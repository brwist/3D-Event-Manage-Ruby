# frozen_string_literal: true

FactoryBot.define do
  factory :label do
    association(:event)
    text { Faker::Lorem.words.join(' ') }

    after(:create) do |label|
      label.update!(external_id: label.id.to_s)
    end
  end
end
