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

    trait :with_pdf_file do
      file { Rack::Test::UploadedFile.new('spec/fixtures/files/dummy.pdf', 'application/pdf') }
    end

    trait :with_jpeg_file do
      file { Rack::Test::UploadedFile.new('spec/fixtures/files/dummy.jpeg', 'image/jpeg') }
    end

    trait :with_png_file do
      file { Rack::Test::UploadedFile.new('spec/fixtures/files/dummy.png', 'image/png') }
    end
  end
end
