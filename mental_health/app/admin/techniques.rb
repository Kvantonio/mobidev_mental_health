ActiveAdmin.register Technique do

  permit_params :title, :description, :age_range, :gender, :duration, :image

  filter :title
  filter :gender
  filter :duration

  form do |f|
    f.inputs do
      f.input :title
      f.input :description
      f.input :image, as: :file
      f.input :age_range
      f.input :gender
      f.input :duration
    end
    f.actions
  end
end
