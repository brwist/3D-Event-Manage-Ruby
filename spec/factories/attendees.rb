# frozen_string_literal: true

FactoryBot.define do
  factory :attendee do
    association(:event)
    name  { Faker::Name.name }
    email { Faker::Internet.email(name: name) }
    encrypted_password { '$2a$12$tjxK/7SiNF8o57aa/DGnH.WMdCt4zEYV.T9MDttEOQD1c.tBoZF6W' }
  end
end
