# frozen_string_literal: true

class AttendeesImporter
  def initialize(event, file)
    @event = event
    @file = file
  end

  def call
    return if data.nil?

    @event.attendees.destroy_all

    data.each do |data_item|
      @event.attendees.create(data_item.slice(:name, :email))
    end
  end

  def errors
    @errors ||= []
  end

  def errors_report
    errors.map do |e|
      e.values_at(:message, :exception).compact.join(": ")
    end.join('. ')
  end

  private

  def data
    @data ||= SmarterCSV.process(@file)
  rescue StandardError => e
    register_error "Processing csv file error (#{@file.original_filename})", e
    nil
  end

  def register_error(message, exception = nil)
    errors << { message: message, exception: exception }
  end
end
