# frozen_string_literal: true

class Room < ApplicationRecord
  has_many :hotspot_tokens
  has_many :label_tokens

  def to_s
    name
  end
end
