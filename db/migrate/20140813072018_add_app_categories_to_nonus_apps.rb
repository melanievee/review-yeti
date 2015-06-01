class AddAppCategoriesToNonusApps < ActiveRecord::Migration
  def change
  	App.all.each do |app|
  		if app.category.nil?
	  		puts app.name
	  		begin
		  		response = HTTParty.get("https://itunes.apple.com/au/rss/customerreviews/id=#{app.itunesid}/sortBy=mostRecent/xml")
		  		app.update_attribute(:category, response["feed"]["entry"][0]["category"]["term"])
		  		app.save
		  	rescue
		  		begin
			  		response = HTTParty.get("https://itunes.apple.com/ca/rss/customerreviews/id=#{app.itunesid}/sortBy=mostRecent/xml")
			  		app.update_attribute(:category, response["feed"]["entry"][0]["category"]["term"])
			  		app.save
			  	rescue
			  		begin
				  		response = HTTParty.get("https://itunes.apple.com/gb/rss/customerreviews/id=#{app.itunesid}/sortBy=mostRecent/xml")
				  		app.update_attribute(:category, response["feed"]["entry"][0]["category"]["term"])
				  		app.save
				  	rescue
		  				puts "Skipping #{app.name} with ID: #{app.id}."
		  			end
		  		end
		  	end
		  end
  	end
  end
end
