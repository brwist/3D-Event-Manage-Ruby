# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ForgeryProtection
  include Pundit
  include SetPlatform

  rescue_from Pundit::NotAuthorizedError, with: :permission_denied

  layout :layout_by_resource

  before_action :authenticate_user!

  def access_denied(exception)
    redirect_to root_url, alert: exception.message
  end

  private

  def after_sign_in_path_for(resource)
    return root_path unless resource.is_a?(Attendee)

    event_attendee_path(resource.event_id, resource)
  end

  def permission_denied
    head 403
  end

  def layout_by_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end
end
