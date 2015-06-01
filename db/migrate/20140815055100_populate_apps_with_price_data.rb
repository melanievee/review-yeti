class PopulateAppsWithPriceData < ActiveRecord::Migration
  def change
  	App.all.each do |app|
  		if app.currency.nil?
	  		puts app.name
	  		begin
		  		response = HTTParty.get("https://itunes.apple.com/us/rss/customerreviews/id=#{app.itunesid}/sortBy=mostRecent/xml")
		  		app.update_attribute(:price, response["feed"]["entry"][0]["price"]["amount"].to_f)
		  		app.update_attribute(:currency, response["feed"]["entry"][0]["price"]["currency"])
		  		app.save
		  	rescue
		  		begin
			  		response = HTTParty.get("https://itunes.apple.com/au/rss/customerreviews/id=#{app.itunesid}/sortBy=mostRecent/xml")
			  		app.update_attribute(:price, response["feed"]["entry"][0]["price"]["amount"].to_f)
		  			app.update_attribute(:currency, response["feed"]["entry"][0]["currency"])
			  		app.save
			  	rescue
			  		begin
				  		response = HTTParty.get("https://itunes.apple.com/ca/rss/customerreviews/id=#{app.itunesid}/sortBy=mostRecent/xml")
				  		app.update_attribute(:price, response["feed"]["entry"][0]["price"]["amount"].to_f)
		  				app.update_attribute(:currency, response["feed"]["entry"][0]["currency"])
				  		app.save
				  	rescue
				  		begin
					  		response = HTTParty.get("https://itunes.apple.com/gb/rss/customerreviews/id=#{app.itunesid}/sortBy=mostRecent/xml")
					  		app.update_attribute(:price, response["feed"]["entry"][0]["price"]["amount"].to_f)
		  					app.update_attribute(:currency, response["feed"]["entry"][0]["currency"])
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
