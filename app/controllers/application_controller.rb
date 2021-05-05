class ApplicationController < ActionController::Base
  include ForgeryProtection
  include SetPlatform

  def access_denied(exception)
    redirect_to root_url, alert: exception.message
  end
end
