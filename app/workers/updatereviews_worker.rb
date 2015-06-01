class UpdatereviewsWorker
	include Sidekiq::Worker
	include WorkersHelper

	def perform(app_id)
		app = App.find(app_id)
		if app.last_scraped.nil?
			ItunesWorker.perform_async(app_id)
			logger.info "App #{app.name} has not been parsed yet. Launched ItunesWorker to perform initial scrape."
		else
			STORES.sort_by { |a| a[:name] }.each do |store|
				logger.info "--> Parsing reviews for #{store[:name]}"
	  		parse_store_rssfeed(app_id, store[:rss_name], store[:name])
			end
			app.update_attribute(:last_scraped, Time.now)
		end
	end
end
