class AddIndexToReviewsAuthor < ActiveRecord::Migration
  def change
  	add_index :reviews, :author
  end
end
