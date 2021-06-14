# frozen_string_literal: true

class AttendeePolicy < AdministratorPolicy
  attr_reader :current_attendee

  def initialize(user, record, current_attendee = nil)
    super(user, record)
    @current_attendee = current_attendee
  end

  def show?
    current_attendee == record || user.admin?
  end
end
