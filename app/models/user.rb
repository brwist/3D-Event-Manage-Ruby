# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :saml_authenticatable, :trackable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true

  before_validation :ensure_password, on: :create

  def admin?
    has_role?(:admin)
  end

  private

  def ensure_password
    return unless password.blank? && password_confirmation.blank?

    self.password = self.password_confirmation = SecureRandom.hex(64)
  end
end
