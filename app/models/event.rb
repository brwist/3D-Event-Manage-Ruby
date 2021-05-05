class Event < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :scoped, scope: :client

  has_many :attendances
  has_many :attendees, through: :attendances, dependent: :destroy

  belongs_to :client

  validates :name, :start_time, :end_time, presence: true
end
