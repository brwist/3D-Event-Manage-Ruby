# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id         :bigint           not null, primary key
#  name       :string           default(""), not null
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_clients_on_name  (name) UNIQUE
#  index_clients_on_slug  (slug) UNIQUE
#
class Client < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :events

  validates :name, presence: true, uniqueness: true
end
