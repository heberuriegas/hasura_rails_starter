ActiveAdmin.register User do
  permit_params :name, :phone_number, :email, :password, :password_confirmation, :role, :is_active
    
  index do
    selectable_column
    id_column
    column :provider
    column :name
    column :email
    column :phone_number
    column :role
    column :is_active
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :name
  filter :email
  filter :phone_number
  filter :role
  filter :is_active
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :phone_number
      f.input :email
      f.input :role, as: :select, collection: [['Administrator', 'admin'], ['User', 'user']]
      f.input :password if f.object.new_record?
      f.input :password_confirmation if f.object.new_record?
      f.input :is_active
    end
    f.actions
  end

end
