ActiveAdmin.register Coach do

  permit_params :name, :email, :coach_avatar, :about, :age, :gender, :password, :password_confirmation

  filter :name
  filter :email
  filter :age
  filter :gender
  filter :current_sign_in_at
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :coach_avatar, as: :file
      f.input :about
      f.input :age
      f.input :gender
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
