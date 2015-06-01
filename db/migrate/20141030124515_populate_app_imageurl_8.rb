class PopulateAppImageurl8 < ActiveRecord::Migration
  def change
  	App.where("imageurl is NULL").each do |app|
  		if app.imageurl.nil?
	  		puts app.name
	  		begin
		  		response = HTTParty.get("https://itunes.apple.com/us/rss/customerreviews/id=#{app.itunesid}/sortBy=mostRecent/xml")
		  		app.update_attribute(:imageurl, response["feed"]["entry"][0]["image"][0]["__content__"])
		  		app.save
		  	rescue
		  		begin
			  		response = HTTParty.get("https://itunes.apple.com/au/rss/customerreviews/id=#{app.itunesid}/sortBy=mostRecent/xml")
			  		app.update_attribute(:imageurl, response["feed"]["entry"][0]["image"][0]["__content__"])
			  		app.save
			  	rescue
			  		begin
				  		response = HTTParty.get("https://itunes.apple.com/ca/rss/customerreviews/id=#{app.itunesid}/sortBy=mostRecent/xml")
				  		app.update_attribute(:imageurl, response["feed"]["entry"][0]["image"][0]["__content__"])
			  			app.save
				  	rescue
				  		begin
					  		response = HTTParty.get("https://itunes.apple.com/gb/rss/customerreviews/id=#{app.itunesid}/sortBy=mostRecent/xml")
					  		app.update_attribute(:imageurl, response["feed"]["entry"][0]["image"][0]["__content__"])
			  				app.save
					  	rescue
			  				puts "***********************************Skipping #{app.name} with ID: #{app.id}."
			  			end
		  			end
		  		end
		  	end
		  end
		end
  end
end
