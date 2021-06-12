# frozen_string_literal: true

class Devise::Attendees::PasswordsController < Devise::PasswordsController
  prepend_before_action :deny_action, except: %i[edit]

  # GET /attendees/password/edit?reset_password_token=abcdef
  def edit
    self.resource = Attendee.new
    set_minimum_password_length
    resource.reset_password_token = params[:reset_password_token]
  end

  private

  # Does not allow to reset password
  def deny_action
    raise ActionController::RoutingError, 'Not Found'
  end
end
