# Adapted from https://github.com/jeremywohl/iphone-scripts/blob/master/appstore_reviews

class ItunesWorker
	include Sidekiq::Worker 
	include WorkersHelper
	
	attr_accessor :app

	def perform(app_id)
		self.app = App.find(app_id)
		logger.info "Entering the scrape iTunes code for App with ID: #{app_id}."
		STORES.sort_by { |a| a[:name] }.each do |store|
			parse_storefront(app_id, store)
		end
		app.update_attribute(:last_scraped, Time.now)
		logger.info "App scrape complete for App ID #{app_id}"
	end
end