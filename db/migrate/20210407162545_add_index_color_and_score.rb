class AddIndexColorAndScore < ActiveRecord::Migration[6.1]
  def change
    add_index :titles, :color
    add_index :titles, :score
  end
end
