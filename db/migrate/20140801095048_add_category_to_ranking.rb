class AddCategoryToRanking < ActiveRecord::Migration
  def change
  	add_column :rankings, :category, :string
  	add_index :rankings, :category
  end
end
