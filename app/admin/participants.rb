ActiveAdmin.register Participant do
  permit_params :full_name, :first_name, :last_name

  filter :full_name
  filter :first_name
  filter :last_name
  filter :created_at
  filter :updated_at
  filter :acted_in_titles_title, as: :string

  show do
    attributes_table do
      row :full_name
      row :first_name
      row :last_name
      row :created_at
      row :updated_at
    end

    columns do
      column do
        panel "Acting Titles" do
          header_action link_to('Add Title', '#')

          table_for participant.acted_in_titles.order(year: :desc) do
            column :id
            column :title
            column :year
          end
        end
      end

      column do
        panel "Directed Titles" do
          para "No data available yet"
        end
      end
    end

    active_admin_comments
  end
end
