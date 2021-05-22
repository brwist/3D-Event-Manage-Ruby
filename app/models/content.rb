# frozen_string_literal: true

class Content < ApplicationRecord
  acts_as_taggable_on :tags

  if Rails.env.production?
    has_one_attached :file, service: :content_storage
  else
    has_one_attached :file
  end

  validates :name, presence: true
end
