ActiveAdmin.register Appearance do
  permit_params :title_id, :participant_id, :role

  filter :title_title, as: :string
  filter :participant_full_name, as: :string
  filter :role, as: :select
  filter :create_at
  filter :updated_at
end
