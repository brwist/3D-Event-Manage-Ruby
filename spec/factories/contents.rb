# frozen_string_literal: true

# == Schema Information
#
# Table name: contents
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :content do
    name { Faker::File.name }
    file { Rack::Test::UploadedFile.new('spec/fixtures/files/dummy.pdf', 'application/pdf') }
  end
end
