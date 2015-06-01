class PopulateAppStoreAndVersionLists < ActiveRecord::Migration
  def change
  	App.order(:id).each do |app|
  		puts "Updating #{app.name}, id: #{app.id}"
  		stores = app.reviews.pluck(:store).uniq
  		versions = app.reviews.pluck(:version).uniq
  		app.update_attribute(:store_list, app.store_list | stores)
  		app.update_attribute(:version_list, app.version_list | versions)
  	end
  end
end
