# frozen_string_literal: true

# == Schema Information
#
# Table name: attendees
#
#  id                 :bigint           not null, primary key
#  email              :string           default(""), not null
#  encrypted_password :string           default(""), not null
#  name               :string           default(""), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  event_id           :bigint           not null
#
# Indexes
#
#  index_attendees_on_email_and_event_id  (email,event_id) UNIQUE
#  index_attendees_on_event_id            (event_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
FactoryBot.define do
  factory :attendee do
    association(:event)
    name  { Faker::Name.name }
    email { Faker::Internet.email(name: name) }
    encrypted_password { '$2a$12$tjxK/7SiNF8o57aa/DGnH.WMdCt4zEYV.T9MDttEOQD1c.tBoZF6W' }
  end
end
