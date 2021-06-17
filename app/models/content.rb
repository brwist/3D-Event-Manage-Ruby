# frozen_string_literal: true

# == Schema Information
#
# Table name: contents
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Content < ApplicationRecord
  ALLOWED_MIME_TYPES = %w[
    application/pdf
    image/jpeg
    image/png
    image/webp
    video/mp4
    image/gif
    image/gif
    application/vnd.ms-powerpoint
    application/vnd.openxmlformats-officedocument.presentationml.presentation
  ].freeze

  acts_as_taggable_on :tags

  has_many :hotspots, dependent: :destroy
  has_one_attached :file

  validates :name, presence: true

  delegate :key, to: :file, allow_nil: false, prefix: true

  scope :images, -> { joins(:file_attachment, :file_blob).where("content_type LIKE 'image/%'") }

  def self.mime_types
    ALLOWED_MIME_TYPES.join(', ')
  end
end
