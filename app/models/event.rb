class Event < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :scoped, scope: :client

  belongs_to :client

  validates :name, :start_time, :end_time, presence: true
end
