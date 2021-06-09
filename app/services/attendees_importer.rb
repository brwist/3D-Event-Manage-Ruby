# frozen_string_literal: true

class AttendeesImporter
  attr_reader :errors, :logs

  def initialize(event, file)
    @event = event
    @file = file
    @errors = []
    @logs = []
  end

  def call
    return if data.nil?

    @event.attendees.destroy_all
    data.each { |data_item| import(data_item) }
  end

  def errors_report
    errors.map do |e|
      e.values_at(:message, :exception).compact.join(': ')
    end.join('. ')
  end

  def logs_html_report
    logs.map do |obj|
      html_class = obj[:success] ? 'text-success' : 'text-danger'
      if obj[:data_item].nil?
        obj[:message]
      else
        "#{obj[:data_item].to_json} --- <span class='#{html_class}'>#{obj[:message]}</span>"
      end
    end.join('<br/>')
  end

  private

  def import(data_item)
    att = @event.attendees.build(data_item.slice(:name, :email, :password))

    args =
      if att.save
        { message: 'Attendee created' }
      else
        { success: false, message: "Attendee errors: #{att.errors.full_messages.join(',')}" }
      end

    add_logs(args.merge(data_item: data_item.except(:password)))
  end

  def add_logs(message:, data_item: nil, success: true)
    logs << ({
      success: success,
      message: message,
      data_item: data_item
    })
  end

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
