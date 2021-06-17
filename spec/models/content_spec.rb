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
end
