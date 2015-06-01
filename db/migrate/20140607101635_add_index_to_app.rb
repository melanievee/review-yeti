class AddIndexToApp < ActiveRecord::Migration
  def change
  	add_index :apps, :itunesid
  end
end
