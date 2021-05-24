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
  acts_as_taggable_on :tags

  has_one_attached :file

  validates :name, presence: true
end
