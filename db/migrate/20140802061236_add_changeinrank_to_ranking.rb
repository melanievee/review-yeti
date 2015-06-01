class AddChangeinrankToRanking < ActiveRecord::Migration
  def change
  	add_column :rankings, :changeinrank, :integer
  end
end
