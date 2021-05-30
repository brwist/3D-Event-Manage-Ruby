# frozen_string_literal: true

ActiveAdmin.register Config do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :value
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :value]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  action_item :publish_all do
    link_to 'Publish Config', :publish_all_admin_configs, method: :put
  end

  collection_action :publish_all, method: :put do
    Config.publish_all
    redirect_to :admin_configs, notice: 'Configs Published!'
  end
end
