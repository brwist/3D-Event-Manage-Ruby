# frozen_string_literal: true

FactoryBot.define do
  factory :experience do
    path  { Faker::Internet.domain_word }
  end
end
