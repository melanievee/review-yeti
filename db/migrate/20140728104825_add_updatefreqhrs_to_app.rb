class AddUpdatefreqhrsToApp < ActiveRecord::Migration
  def change
  	add_column :apps, :updatefreqhrs, :integer
  	add_index :apps, :updatefreqhrs
  end
end
