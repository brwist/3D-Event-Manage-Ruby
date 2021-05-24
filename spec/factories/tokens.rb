# frozen_string_literal: true

FactoryBot.define do
  factory :token do
    association(:room)

    name { Faker::ChuckNorris.fact }
    token { Faker::Hipster.words.join('-') }
  end
end
