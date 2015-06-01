class AddLastScrapedToApp < ActiveRecord::Migration
  def change
  	add_column :apps, :last_scraped, :datetime
  end
end
