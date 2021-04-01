ActiveAdmin.register Title do
  permit_params :title, :type, :year, :image_url, :color, :score, :rating

  index do
    selectable_column
    id_column
    column(:image) { |title| image_tag title.image_url }
    column :title
    column :type
    column :year
    column(:color) { |title| div style: "background-color: #{title.color}; width: 32px; height: 32px;" }
    column(:score) { |title| title.score&.round(2) }
    column :rating
    column :created_at
    column :updated_at
    actions
  end
end
