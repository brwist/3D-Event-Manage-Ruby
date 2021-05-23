# frozen_string_literal: true

ActiveAdmin.register Token do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #

  permit_params :type, :name, :token, :room_id

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
    column :type
    column :name
    column :token
    column :room
    actions
  end

  form do |f|
    f.inputs do
      f.input :type, as: :select, collection: Token.descendants.map(&:name), include_blank: false
      f.input :name
      f.input :token
      f.input :room
    end
    f.actions
  end
end
