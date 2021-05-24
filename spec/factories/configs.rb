# frozen_string_literal: true

# == Schema Information
#
# Table name: configs
#
#  id         :bigint           not null, primary key
#  name       :string
#  value      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_configs_on_name  (name) UNIQUE
#
FactoryBot.define do
  factory :config do
    name { 'MyString' }
    value { 'MyString' }
  end
end
