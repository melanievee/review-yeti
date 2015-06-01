class RemoveVotesFromReviews < ActiveRecord::Migration
  def change
  	remove_column :reviews, :votecount
  	remove_column :reviews, :votesum
  end
end
