# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConfigPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:user) { User.new }
  let(:admin) { build(:user, :admin) }

  it { is_expected.to be < AdministratorPolicy }

  permissions :publish? do
    it 'only allows administrator' do
      expect(policy).not_to permit(user, User.new)
      expect(policy).to permit(admin, User.new)
    end
  end
end
