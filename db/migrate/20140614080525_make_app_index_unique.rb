class MakeAppIndexUnique < ActiveRecord::Migration
  def change
  	remove_index :apps, :itunesid
  	add_index :apps, :itunesid, unique: true
  end
end
