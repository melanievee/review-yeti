class PopulateAppUpdatefreqhrs < ActiveRecord::Migration
  def change
  	App.all.each do |app|
  		app.updatefreqhrs = 1
  		app.save
  	end
  end
end
