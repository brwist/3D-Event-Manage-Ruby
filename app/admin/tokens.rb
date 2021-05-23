# frozen_string_literal: true

ActiveAdmin.register Token do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #

  permit_params :name, :token, :room_id, :content

  #
  # or
  #
  # permit_params do
  #   permitted = [:type, :name, :token, :room_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    selectable_column
    id_column
    column :room
    column :name
    column :token
    column :content
    actions
  end

  form do |f|
    f.inputs do
      f.input :room
      f.input :name
      f.input :token
      f.input :content
    end
    f.actions
  end
end
