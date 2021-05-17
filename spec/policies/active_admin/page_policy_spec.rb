# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActiveAdmin::PagePolicy, type: :policy do
  subject { described_class }

  it { is_expected.to be < AdministratorPolicy }
end
