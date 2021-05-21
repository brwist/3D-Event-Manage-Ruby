# frozen_string_literal: true

class Content < ApplicationRecord
  acts_as_taggable_on :tags

  has_one_attached :essence

  validates :name, presence: true
end
