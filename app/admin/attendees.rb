# frozen_string_literal: true

ActiveAdmin.register Attendee do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :event_id, :name, :email, :password, :password_confirmation
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :email, :encrypted_password]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  #

  form do |f|
    f.inputs do
      f.input :event
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
