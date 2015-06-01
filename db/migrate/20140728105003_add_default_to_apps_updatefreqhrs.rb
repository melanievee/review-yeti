class AddDefaultToAppsUpdatefreqhrs < ActiveRecord::Migration
  def change
  	change_column :apps, :updatefreqhrs, :integer, default: 1
  end
end
