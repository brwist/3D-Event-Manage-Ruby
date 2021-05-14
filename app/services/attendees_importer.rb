class AttendeesImporter
  def initialize(event, file)
    @event = event
    @file = file
  end

  def call
    return if data.nil?
    @event.attendances.destroy_all

    data.each do |data_item|
      attendee = Attendee.find_or_create_by(data_item.slice(:name, :email))
      @event.attendees << attendee if attendee.persisted?
    end
  end

  def errors
    @errors ||= []
  end

  private

  def data
    @data ||= SmarterCSV.process(@file)
  rescue StandardError => e
    register_error "Processing csv file error (#{@file.original_filename})", e
    nil
  end

  def register_error(message, exception=nil)
    errors << { message: message, exception: exception }
  end
end
