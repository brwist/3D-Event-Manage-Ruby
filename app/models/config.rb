# frozen_string_literal: true

class Config < ApplicationRecord
  validates :name, uniqueness: true

  class << self
    def get(name, default: '')
      find_by(name: name)&.value || default
    end
  end
end
