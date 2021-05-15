# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email      { Faker::Internet.email }
    password   { '12345678' }
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }

    trait :admin do
      after(:build) do |user|
        user.add_role(:admin)
      end
    end
  end
end
