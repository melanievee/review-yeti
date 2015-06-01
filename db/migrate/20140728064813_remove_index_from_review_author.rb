class RemoveIndexFromReviewAuthor < ActiveRecord::Migration
  def change
  	remove_index :reviews, :author
  end
end
