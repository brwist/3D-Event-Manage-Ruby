# frozen_string_literal: true

class Event < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :scoped, scope: :client

  has_many :attendees
  has_many :hotspots

  belongs_to :client
  belongs_to :main_entrance, class_name: 'Experience'

  delegate :slug, to: :client, prefix: true, allow_nil: true
  delegate :path, to: :main_entrance, prefix: true, allow_nil: true

  validates :name, :start_time, :end_time, presence: true

  def key
    "#{client_slug}.#{slug}"
  end

  def configuration_key
    "event.#{key}"
  end

  def publish
    Redis.current.hset(configuration_key, 'main_entrance', main_entrance_path)

    attendees.each(&:publish)
    hotspots.each(&:publish)
  end
end
