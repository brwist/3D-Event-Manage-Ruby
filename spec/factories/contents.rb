# frozen_string_literal: true

FactoryBot.define do
  factory :content do
    name { Faker::File.name }
    file { Rack::Test::UploadedFile.new('spec/fixtures/files/dummy.pdf', 'application/pdf') }
  end
end
