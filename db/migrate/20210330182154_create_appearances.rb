class CreateAppearances < ActiveRecord::Migration[6.1]
  def change
    create_table :appearances do |t|
      t.references :title, null: false, foreign_key: true
      t.references :participant, null: false, foreign_key: true
      t.integer :role

      t.timestamps
    end

    add_index :appearances, :role
    add_index :appearances, [:role, :participant_id, :title_id], unique: true
  end
end
