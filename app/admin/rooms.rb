# frozen_string_literal: true

ActiveAdmin.register Room do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #

  permit_params :name, :path, :appearance

  #
  # or
  #
  # permit_params do
  #   permitted = [:path]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    selectable_column
    id_column
    column :name
    column :path
    column :appearance do |room|
      room.appearance.attached? ? room.appearance.filename.to_s : nil
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :path
      f.input :appearance, as: :file, hint: f.object.appearance.attached? ? f.object.appearance.filename.to_s : nil
    end
    f.actions
  end
end
