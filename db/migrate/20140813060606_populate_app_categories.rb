class PopulateAppCategories < ActiveRecord::Migration
  def change
  	App.all.each do |app|
  		puts app.name
  		begin
	  		response = HTTParty.get("https://itunes.apple.com/us/rss/customerreviews/id=#{app.itunesid}/sortBy=mostRecent/xml")
	  		app.update_attribute(:category, response["feed"]["entry"][0]["category"]["term"])
	  		app.save
	  	rescue
	  		puts "Skipping #{app.name} with ID: #{app.id}."
	  	end
  	end
  end
end
