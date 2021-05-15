class Event < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :scoped, scope: :client

  has_many :attendances
  has_many :attendees, through: :attendances, dependent: :destroy

  belongs_to :client

  delegate :slug, to: :client, prefix: true, allow_nil: true

  validates :name, :start_time, :end_time, presence: true
end
