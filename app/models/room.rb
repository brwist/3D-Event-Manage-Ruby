# frozen_string_literal: true

class Room < ApplicationRecord
  has_many :tokens, dependent: :destroy

  def to_s
    name
  end
end
