require 'rails_helper'

RSpec.describe EventPolicy, type: :policy do
  subject { described_class }

  it { is_expected.to be < AdministratorPolicy }
end
