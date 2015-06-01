class RemoveChangeinrankFromRanking < ActiveRecord::Migration
  def change
  	remove_column :rankings, :changeinrank
  end
end
