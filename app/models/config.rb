# frozen_string_literal: true

# == Schema Information
#
# Table name: configs
#
#  id         :bigint           not null, primary key
#  name       :string
#  value      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_configs_on_name  (name) UNIQUE
#
class Config < ApplicationRecord
  validates :name, uniqueness: true

  class << self
    def get(name, default: '')
      find_by(name: name)&.value || default
    end
  end
end
