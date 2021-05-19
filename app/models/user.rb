# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :saml_authenticatable, :trackable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true

  def admin?
    has_role?(:admin)
  end
end
