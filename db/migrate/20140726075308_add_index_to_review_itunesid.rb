class AddIndexToReviewItunesid < ActiveRecord::Migration
  def change
  	add_index :reviews, :itunesid
  end
end
