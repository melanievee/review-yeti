class AddPulldateToRanking < ActiveRecord::Migration
  def change
  	add_column :rankings, :pulldate, :datetime
  	add_index :rankings, :pulldate
  end
end
