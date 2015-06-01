class AddStoreAndVersionListsToAppModel < ActiveRecord::Migration
  def change
  	add_column :apps, :store_list, :string, array: true, default: []
  	add_column :apps, :version_list, :string, array: true, default: []
  end
end
