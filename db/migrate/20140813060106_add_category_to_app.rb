class AddCategoryToApp < ActiveRecord::Migration
  def change
  	add_column :apps, :category, :string
  end
end
