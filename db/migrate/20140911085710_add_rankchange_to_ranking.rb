class AddRankchangeToRanking < ActiveRecord::Migration
  def change
  	add_column :rankings, :change12hr, :integer
  	add_column :rankings, :change24hr, :integer
  end
end
