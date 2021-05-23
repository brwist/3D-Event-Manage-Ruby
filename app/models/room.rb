# frozen_string_literal: true

class Room < ApplicationRecord
  has_many :tokens

  def to_s
    name
  end
end
