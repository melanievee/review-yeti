class AddItunesidToReview < ActiveRecord::Migration
  def change
  	add_column :reviews, :itunesid, :integer, :limit => 8
  end
end
