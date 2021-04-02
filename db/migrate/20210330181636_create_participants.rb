class CreateParticipants < ActiveRecord::Migration[6.1]
  def change
    create_table :participants do |t|
      t.string :full_name
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
    add_index :participants, :full_name, unique: true
    add_index :participants, :first_name
    add_index :participants, :last_name
  end
end
