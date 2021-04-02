class CreateTitles < ActiveRecord::Migration[6.1]
  def change
    create_table :titles do |t|
      t.string :title
      t.string :type
      t.integer :year
      t.string :image_url
      t.string :color
      t.decimal :score
      t.integer :rating

      t.timestamps
    end
    add_index :titles, :title
    add_index :titles, :type
    add_index :titles, :year
  end
end
