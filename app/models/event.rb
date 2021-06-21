# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id                       :bigint           not null, primary key
#  end_time                 :datetime
#  invitation_scheduled     :boolean          default(FALSE)
#  invitation_sent          :boolean          default(FALSE)
#  landing_background_color :string
#  landing_foreground_color :string
#  landing_logo             :string
#  landing_prompt           :string
#  name                     :string
#  send_invitation_at       :datetime
#  slug                     :string
#  start_time               :datetime
#  timezone                 :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  client_id                :bigint           not null
#  main_entrance_id         :bigint
#
# Indexes
#
#  index_events_on_client_id         (client_id)
#  index_events_on_main_entrance_id  (main_entrance_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (main_entrance_id => rooms.id)
#
class Event < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :scoped, scope: :client

  acts_as_taggable_on :tags

  has_many :attendees, dependent: :destroy
  has_many :hotspots, dependent: :destroy
  has_many :labels, dependent: :destroy

  belongs_to :client
  belongs_to :main_entrance, class_name: 'Room'

  delegate :slug, to: :client, prefix: true, allow_nil: true
  delegate :path, to: :main_entrance, prefix: true, allow_nil: true
  delegate :name, to: :client, prefix: true, allow_nil: true

  validates :name,
            :start_time,
            :end_time,
            :landing_prompt,
            :landing_logo,
            :landing_background_color,
            :landing_foreground_color, presence: true

  validates :timezone, inclusion: ActiveSupport::TimeZone.all.map(&:name)

  def key
    "#{client_slug}.#{slug}"
  end

  def configuration_key
    "event.#{key}"
  end

  def unpublish
    unpublish_event

    Attendee.unpublish(key)
    Hotspot.unpublish(key)
    Label.unpublish(key)
  end

  def publish
    publish_event

    # clean related models records before publish
    Attendee.unpublish(key)
    attendees.each(&:publish)

    Hotspot.unpublish(key)
    hotspots.each(&:publish)

    Label.unpublish(key)
    labels.each(&:publish)
  end

  def router_app_url
    "#{Config.event_url_root}/#{client_slug}/#{slug}"
  end

  private

  def unpublish_event
    Redis.current.del(configuration_key)
  end

  # rubocop:disable Metrics/AbcSize
  def publish_event
    Redis.current.hset(configuration_key, 'main_entrance', main_entrance_path)
    Redis.current.hset(configuration_key, 'start_time', time_to_publish_format(start_time))
    Redis.current.hset(configuration_key, 'end_time', time_to_publish_format(end_time))
    Redis.current.hset(configuration_key, 'timezone', timezone)
    Redis.current.hset(configuration_key, 'landing_prompt', landing_prompt)
    Redis.current.hset(configuration_key, 'landing_logo', landing_logo)
    Redis.current.hset(configuration_key, 'landing_background_color', landing_background_color)
    Redis.current.hset(configuration_key, 'landing_foreground_color', landing_foreground_color)
  end
  # rubocop:enable Metrics/AbcSize

  def time_to_publish_format(time)
    (time.to_i * 1000).to_s
  end
end
