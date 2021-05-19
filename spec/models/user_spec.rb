# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { create(:user) }

  describe 'SAML password handeling' do
    it 'generates password on creation when no password is provided' do
      created_user = described_class.create!(email: Faker::Internet.email, first_name: 'First', last_name: 'Name').encrypted_password
      expect(created_user).not_to be_empty
    end
  end
end
