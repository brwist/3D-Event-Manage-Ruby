# frozen_string_literal: true

namespace :hotspots do
  task link_labels: :environment do
    Label.where(external_id: Hotspot.where(label_id: nil).map(&:external_id)).each do |label|
      puts "Linking label to Hotspot#{label.token}"
      Hotspot.find_by(external_id: l.external_id).update!(label: label)
    end
  end
end
