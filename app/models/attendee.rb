class Attendee < ApplicationRecord
  devise :database_authenticatable

  belongs_to :event

  validates :name, :email, presence: true
end
