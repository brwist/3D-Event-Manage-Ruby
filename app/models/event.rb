# frozen_string_literal: true

class Event < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :scoped, scope: :client

  has_many :attendees
  has_many :hotspots
  has_many :labels

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
    publish_event

    attendees.each(&:publish)
    hotspots.each(&:publish)
    labels.each(&:publish)
  end

  private

  def publish_event
    Redis.current.hset(configuration_key, 'main_entrance', main_entrance_path)
    Redis.current.hset(configuration_key, 'start_time', time_to_publish_format(start_time))
    Redis.current.hset(configuration_key, 'end_time', time_to_publish_format(end_time))
  end

  def time_to_publish_format(time)
    (time.to_i * 1000).to_s
  end
end
