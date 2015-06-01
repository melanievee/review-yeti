class CreateRankings < ActiveRecord::Migration
  def change
    create_table :rankings do |t|
      t.integer :rank
      t.integer :app_id

      t.timestamps
    end

    add_index :rankings, :app_id
  end
end
