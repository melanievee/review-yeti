class AppsController < ApplicationController
	before_action :signed_in_user, only: [:create, :show]

	def new
		@app = App.new
	end

	def create
		@app = App.find_by(itunesid: app_params[:itunesid])
		if current_user.can_follow_more_apps?
			if @app
				scrape_itunes(@app.id) unless @app.followers.count > 0
				current_user.follow!(@app)
				flash[:success] = "Woo hoo!  You are following that App!"
			else
				@app = App.new(app_params)
				if find_app_in_itunes
					@app.save
					scrape_itunes(@app.id)
					current_user.follow!(@app)
					flash[:success] = "Woo hoo!  You are following that App!"
				else
					flash[:error] = "We're sorry, an app with that ID was not found in the iTunes App Store." 
				end
			end
		else
			flash[:error] = "Oops! Don't forget, beta users can only follow one app at a time."
		end
		redirect_to root_url
	end

	def rankings
		@app = App.find(params[:id])
		@rankings = @app.rankings
	end

	def reviews
		@app = App.find(params[:id])
		@search = @app.reviews.search(params[:q])
		@reviews = @search.result
		@reviews_paginated = @reviews.paginate(:page => params[:review_page], :per_page => 100)
		@word_array = create_word_array
		@store = @app.store_list
		@version = @app.version_list
	end

	def show
		redirect_to reviews_app_path
	end

	private

		def app_params
			params.require(:app).permit(:itunesid)
		end

		def scrape_itunes(app_id)
			ItunesWorker.perform_async(app_id)
		end

		# Pings the US store xml feed to see if app exists.  LATER: ADD LOOP TO SEARCH ALL STORES!
		def find_app_in_itunes
			response = HTTParty.get("https://itunes.apple.com/us/rss/customerreviews/id=#{app_params[:itunesid]}/sortBy=mostRecent/xml")
			if !response.to_s.include?("artist")
				response = HTTParty.get("https://itunes.apple.com/au/rss/customerreviews/id=#{app_params[:itunesid]}/sortBy=mostRecent/xml")
				if !response.to_s.include?("artist")
					response = HTTParty.get("https://itunes.apple.com/ca/rss/customerreviews/id=#{app_params[:itunesid]}/sortBy=mostRecent/xml")
					if !response.to_s.include?("artist")
						response = HTTParty.get("https://itunes.apple.com/uk/rss/customerreviews/id=#{app_params[:itunesid]}/sortBy=mostRecent/xml")
					end
				end
			end

			if response.to_s.include?("artist")
				@app.update_attribute(:name,response["feed"]["entry"][0]["name"])
				@app.update_attribute(:artist, response["feed"]["entry"][0]["artist"]["__content__"])
				@app.update_attribute(:category, response["feed"]["entry"][0]["category"]["term"])
				@app.update_attribute(:price, response["feed"]["entry"][0]["price"]["amount"].to_f)
				@app.update_attribute(:currency, response["feed"]["entry"][0]["price"]["currency"])
				@app.update_attribute(:imageurl, response["feed"]["entry"][0]["image"].first["__content__"])
			end
			response.to_s.include?("artist")
  	end

  	def update_reviews(app_id)
  		UpdatereviewsWorker.perform_async(app_id)
    end	

    def create_word_array
    	raw_content = @reviews.limit(1000).pluck(:content)
			content = raw_content.to_s.downcase.tr('^a-z| ', '')
			stopwords = ["a","all","am","an","and","any","are","aren't","as","at","be","because","been","both","but","by","can't","cannot","could","couldn't","did","didn't","do","does","doesn't","don't","each","few","for","from","had","hadn't","has","hasn't","have","haven't","having","he","he'd","he'll","he's","her","here","here's","hers","herself","him","himself","his","how","how's","i","i'd","i'll","i'm","i've","if","in","into","is","isn't","it","it's","its","itself","let's","me","more","my","no","nor","not","of","off","on","once","only","or","other","ought","our","ours","ourselves","out","own","shan't","she","she'd","she'll","she's","so","some","such","than","that","that's","the","their","theirs","them","themselves","then","there","there's","these","they","they'd","they'll","they're","they've","this","those","to","too","up","was","wasn't","we","we'd","we'll","we're","we've","were","weren't","what","what's","when","when's","where's","which","while","who","who's","whom","why","why's","with","won't","would","wouldn't","you","you'd","you'll","you're","you've","your","yours","yourself","yourselves"]
			words = content.split(" ")
			
			valid_words = words - stopwords
			frequencies = valid_words.frequency
			frequencies = frequencies.sort_by{ |text, count| count }
			frequencies.reverse!
			
			word_array = []
			frequencies.each do |pair|
				word_array.push({text: pair[0], weight: pair[1], link: reviews_app_path(@app, :'q[content_cont]' => pair[0])})
			end
			word_array
    end
end
