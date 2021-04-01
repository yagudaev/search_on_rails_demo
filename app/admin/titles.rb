ActiveAdmin.register Title do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :title, :type, :year, :image_url, :color, :score, :rating
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :type, :year, :image_url, :color, :score, :rating]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    selectable_column
    id_column
    column(:image) { |title| image_tag title.image_url }
    column :title
    column :year
    column(:color) { |title| div style: "background-color: #{title.color}; width: 32px; height: 32px;" }
    column(:score) { |title| title.score&.round(2) }
    column :rating
    column :created_at
    column :updated_at
    actions
  end
end
