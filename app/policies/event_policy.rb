# frozen_string_literal: true

class EventPolicy < AdministratorPolicy
  def publish?
    user.admin?
  end

  def upload_attendees?
    user.admin?
  end
end
