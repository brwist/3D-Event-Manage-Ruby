# frozen_string_literal: true

class EventPolicy < AdministratorPolicy
  def publish?
    user.has_role?(:admin)
  end
end
