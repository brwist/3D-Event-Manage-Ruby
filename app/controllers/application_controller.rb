class ApplicationController < ActionController::Base
  include ForgeryProtection
  include SetPlatform

  layout :layout_by_resource

  before_action :authenticate_user!

  def access_denied(exception)
    redirect_to root_url, alert: exception.message
  end

  private

  def layout_by_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end
end
