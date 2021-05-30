# frozen_string_literal: true

class ConfigPolicy < AdministratorPolicy
  def publish?
    user.has_role?(:admin)
  end
end
