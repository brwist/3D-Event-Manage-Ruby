# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdministratorPolicy, type: :policy do
  subject { described_class }

  let(:user) { User.new }
  let(:admin) { build(:user, :admin) }
  let(:scope) { Pundit.policy_scope!(user, User) }

  permissions '.scope' do
    let!(:other_user) { create(:user) }
    it 'denies by default' do
      expect(scope.to_a).to match_array([])
    end

    context 'admin' do
      let(:user) { build(:user, :admin) }

      it 'allows admin to see everyone' do
        expect(scope.to_a).to match_array([other_user])
      end
    end
  end

  shared_examples_for :only_administrator do
    it do
      expect(subject).not_to permit(user, User.new)
      expect(subject).to permit(admin, User.new)
    end
  end
  permissions :index? do
    it_behaves_like :only_administrator
  end

  permissions :show? do
    it_behaves_like :only_administrator
  end

  permissions :create? do
    it_behaves_like :only_administrator
  end

  permissions :update? do
    it_behaves_like :only_administrator
  end

  permissions :destroy? do
    it_behaves_like :only_administrator
  end
end
