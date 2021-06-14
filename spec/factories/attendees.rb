# frozen_string_literal: true

# == Schema Information
#
# Table name: attendees
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string           default(""), not null
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  event_id               :bigint           not null
#
# Indexes
#
#  index_attendees_on_email_and_event_id    (email,event_id) UNIQUE
#  index_attendees_on_event_id              (event_id)
#  index_attendees_on_reset_password_token  (reset_password_token) UNIQUE
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
    password { '12345678' }
  end
end
