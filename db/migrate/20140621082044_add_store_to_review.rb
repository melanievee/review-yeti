class AddStoreToReview < ActiveRecord::Migration
  def change
  	add_column :reviews, :store, :string
  	add_index :reviews, :store
  end
end
