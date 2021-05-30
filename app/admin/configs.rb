# frozen_string_literal: true

ActiveAdmin.register Config do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :value

  index do
    selectable_column
    id_column
    column :name
    column :value
    actions
  end

  show do
    attributes_table do
      row :name
      row :value
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :name, as: :select,
                     collection: %w[login_background login_logo login_prompt default_redirect],
                     include_blank: false
      f.input :value
    end

    f.actions
  end
  action_item :publish_all do
    link_to 'Publish Config', :publish_all_admin_configs, method: :put
  end

  collection_action :publish_all, method: :put do
    Config.publish_all
    redirect_to :admin_configs, notice: 'Configs Published!'
  end
end
