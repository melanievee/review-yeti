class AddStoreToRanking < ActiveRecord::Migration
  def change
  	add_column :rankings, :store, :string
  	add_index :rankings, :store
  end
end
