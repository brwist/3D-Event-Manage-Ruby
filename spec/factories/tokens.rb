# frozen_string_literal: true

FactoryBot.define do
  factory :token do
    type { '' }
    name { 'MyString' }
    token { 'MyString' }
    room { nil }
  end
end
