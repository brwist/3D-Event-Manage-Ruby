# frozen_string_literal: true

ActiveAdmin.register Hotspot do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :external_id, :event_id, :destination_url, :type, :tooltip
  #
  # or
  #
  # permit_params do
  #   permitted = [:external_id, :event_id, :destination_url, :type, :tooltip]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  form do |f|
    f.inputs do
      f.input :external_id
      f.input :event
      f.input :destination_url
      f.input :type
      f.input :tooltip
    end
    f.actions
  end
end
