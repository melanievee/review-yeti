class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followedapp_id

      t.timestamps
    end
    add_index :relationships, :follower_id
    add_index :relationships, :followedapp_id
    add_index :relationships, [:follower_id, :followedapp_id], unique: true
  end
end
