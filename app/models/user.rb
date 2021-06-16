# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  first_name             :string
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  session_index          :string
#  sign_in_count          :integer          default(0), not null
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise_modules = %i[trackable recoverable rememberable validatable]
  devise_modules << :saml_authenticatable if ENV.fetch('SAML_AUTHENTICATION', 'false') == 'true'
  devise_modules << :database_authenticatable if ENV.fetch('DATABASE_AUTHENTICATION', 'true') == 'true'

  devise(*devise_modules)

  validates :first_name, :last_name, presence: true

  before_validation :ensure_password, on: :create

  def admin?
    (roles.map(&:name) & %w[superadmin admin]).present?
  end

  def superadmin?
    has_role?(:superadmin)
  end

  private

  def ensure_password
    return unless password.blank? && password_confirmation.blank?
    return unless respond_to?(:password=)

    self.password = self.password_confirmation = SecureRandom.hex(64)
  end
end
