ActiveAdmin.register Rating do
  permit_params :user_id, :technique_id, :like, :dislike
end
