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
require 'rails_helper'

RSpec.describe Content, type: :model do
  subject(:content) { create(:content) }

  it { is_expected.to have_many(:hotspots).dependent(:destroy) }

  describe '.images' do
    subject(:images) { described_class.images }

    let!(:image_files) { [create(:content, :with_png_file), create(:content, :with_jpeg_file)] }

    it 'only returns image files' do
      create(:content, :with_pdf_file)
      expect(images).to contain_exactly(*image_files)
    end
  end

  describe 'filesize' do
    it 'does not create a content with large image' do
      jpg_file = Rack::Test::UploadedFile.new('spec/fixtures/files/dummy.jpeg', 'image/jpeg')

      content = described_class.new({
                                      name: 'Test',
                                      file: jpg_file
                                    })
      # simulate large jpg file
      content.file.byte_size = 576_716_80 # 55mb

      content.save

      expect(content.errors[:file].first).to eq 'is too big'
    end

    it 'creates a content with image' do
      jpg_file = Rack::Test::UploadedFile.new('spec/fixtures/files/dummy.jpeg', 'image/jpeg')

      content = described_class.new({
                                      name: 'Test',
                                      file: jpg_file
                                    })
      content.file.byte_size = 471_859_20 # 45mb

      content.save

      expect(content.errors[:file].first).to eq nil
    end

    it 'creates a content with document' do
      ppt_file = Rack::Test::UploadedFile.new('spec/fixtures/files/sample.ppt', 'application/vnd.ms-powerpoint')

      content = described_class.new({
                                      name: 'Test',
                                      file: ppt_file
                                    })
      content.file.byte_size = 13_631_488 # 13mb

      content.save

      expect(content.errors[:file].first).to eq nil
    end

    it 'does not create a content with large document' do
      ppt_file = Rack::Test::UploadedFile.new('spec/fixtures/files/sample.ppt', 'application/vnd.ms-powerpoint')

      content = described_class.new({
                                      name: 'Test',
                                      file: ppt_file
                                    })
      content.file.byte_size = 27_262_976 # 26mb

      content.save

      expect(content.errors[:file].first).to eq 'is too big'
    end
  end
end
