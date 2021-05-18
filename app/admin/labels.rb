# frozen_string_literal: true

ActiveAdmin.register Label do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :external_id, :event_id, :text

  #
  # or
  #
  # permit_params do
  #   permitted = [:external_id, :event_id, :text]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  form do |f|
    f.inputs do
      f.input :external_id
      f.input :event
      f.input :text
    end
    f.actions
  end
end
