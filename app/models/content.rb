# frozen_string_literal: true

class Content < ApplicationRecord
  acts_as_taggable_on :tags

  validates :name, presence: true
end
