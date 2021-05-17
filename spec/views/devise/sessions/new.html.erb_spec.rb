# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'devise/sessions/new', type: :view do
  module DeviseUserBits
    def resource
      User.new
    end

    def resource_name
      :user
    end

    def devise_mapping
      Devise.mappings[:user]
    end
  end

  before do
    view.class.include DeviseUserBits
  end

  it 'renders new event form' do
    render

    assert_select 'form[autocomplete=off]'
  end
end
