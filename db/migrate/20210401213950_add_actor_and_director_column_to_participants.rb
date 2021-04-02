class AddActorAndDirectorColumnToParticipants < ActiveRecord::Migration[6.1]
  def change
    add_column :participants, :actor, :boolean, default: false, null: false
    add_column :participants, :director, :boolean, default: false, null: false

    add_index :participants, :actor
    add_index :participants, :director
  end
end
