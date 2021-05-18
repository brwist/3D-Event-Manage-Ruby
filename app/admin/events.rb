# frozen_string_literal: true

ActiveAdmin.register Event do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :slug, :start_time, :end_time, :client_id, :main_entrance_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :slug, :start_time, :end_time, :client_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  action_item :publish, only: :show do
    link_to 'Publish', publish_admin_event_path, method: :put
  end

  member_action :publish, method: :put do
    resource.publish
    redirect_to resource_path, notice: 'Published!'
  end
end
