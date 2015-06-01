module WorkersHelper

	#### Top-level functions called by Workers
	def parse_store_rssfeed(app_id, store_rss_name, store_name)
		app = App.find(app_id)
		url = "#{base_uri}/#{store_rss_name}/rss/customerreviews/id=#{app.itunesid}/sortBy=mostRecent/xml"
		rss_entries = rss_entries(url)

		unless rss_entries.nil?
			rss_entries.each { |review| parse_rss_review(app, review, store_name) if review["author"] }
		end
	end

	def get_rankings(store_name, store_rss_name, ranking_group_name, ranking_group_itunes_name, ranking_group_genre)
  	rss_entries = rss_entries("#{base_uri}/#{store_rss_name}/rss/#{ranking_group_itunes_name}/limit=200#{genre(ranking_group_genre)}/xml")
  	pulldate = Time.now
  	rss_entries.each_with_index do | entry, rank |
   		parse_ranking(entry, rank, pulldate, store_name, ranking_group_name)
  	end
	end

	def parse_storefront(app_id, store)
		page = 0
		begin
			page_contents = fetch_single_storefront_page(page, store[:id])
			new_review_count = process_single_storefront_page(page_contents, app_id, store[:name])
			page += 1
		end until new_review_count == 0
	end


	### Support methods to parse_store_rssfeed
	def rss_entries(url)
		response = fetch(url)
		response["feed"]["entry"]
	end

	def parse_rss_review(app, review, store_name)
 		reviewitunesid = review["id"].to_i
		if app.reviews.find_by(itunesid: reviewitunesid).nil? #If review does not exist already for this app
			newreview = app.reviews.create(updated: 		DateTime.parse(review["updated"]),
						        									title: 			review["title"],
						        									content: 		review["content"].first["__content__"].gsub("\n"," ").gsub("\r"," ").gsub("&#39;", "\'").gsub("&#34;", "\"").gsub("&amp;", "&").strip, #Add translation later
						        									rating: 		review["rating"].to_i,
						        									author: 		review["author"]["name"],
						        									version: 		review["version"],
						        									author_uri: review["author"]["uri"],
						        									store: 			store_name,
						        									itunesid: 	reviewitunesid)
			if newreview.save
				update_app_store_version_lists(app.id, newreview.store, newreview.version)
			else
	    	logger.error "There has been a review building error: "
	    	logger.error review.errors.full_messages
    	end
    end
 	end


	### Support methods to get_rankings
	def parse_ranking(entry, rank, pulldate, storename, category)
    itunesid = entry["id"]["id"]
    itunesid ||= entry["id"]["im:id"]
    artist = entry["artist"]["__content__"] || entry["artist"]
    if itunesid
    	app = App.find_by(itunesid: itunesid)
	    if app.nil?
	      app = App.create!( 	itunesid:  itunesid,
			                      name:     entry["name"],
			                      artist:   artist,
			                      category: entry["category"]["term"],
			                      price:		entry["price"]["amount"],
			                      currency: entry["price"]["currency"],
			                      imageurl: entry["image"].first["__content__"])
	      change12hr = change24hr = nil
	    else
	    	change12hr = change_in_rank(app.id, category, storename, pulldate, rank, 12)
				change24hr = change_in_rank(app.id, category, storename, pulldate, rank, 24)
	    end
			app.rankings.create(rank: 			rank,
													category: 	category,
													pulldate: 	pulldate,
													store: 			storename,
													change12hr: change12hr,
													change24hr: change24hr)
			app.save
    else
    	logger.warn "No itunesid was found for this entry: #{entry}"
		end
	end

	def change_in_rank(app_id, category, storename, pulldate, rank, time_in_hours)
		timemargin = 4
		prevrank = Ranking.find_by_sql("SELECT * FROM rankings WHERE (app_id = '#{app_id}'
			AND category = '#{category}'
			AND store = '#{storename}'
			AND pulldate > '#{pulldate-time_in_hours.hours-timemargin.hours}'
			AND pulldate < '#{pulldate-time_in_hours.hours+timemargin.hours}')
		  ORDER BY ABS(extract(epoch from (pulldate-'#{pulldate-time_in_hours.hours}')))").first.try(:rank) || nil
		change = (prevrank - rank) unless prevrank.nil?
	end

	### Support methods to parse_storefront
	def fetch_single_storefront_page(pagenum, storeid)
	  response = fetch("#{base_uri}/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=#{app.itunesid}&pageNumber=#{pagenum}&sortOrdering=1&type=Purple+Software", { "X-Apple-Store-Front" => "#{storeid}-1" })
	  parse_xml(response.body)
	end

	def process_single_storefront_page(page_contents, app_id, storename)
		raw_reviews = page_contents.search("Document > View > ScrollView > VBoxView > View > MatrixView > VBoxView:nth(0) > VBoxView > VBoxView")
		new_reviews = 0
		if reviews_exist(raw_reviews)
			raw_reviews.each do |raw_review|
		    parse_review(app_id, storename, raw_review)
		    new_reviews += 1
		  end
		end
		new_reviews
	end

	def reviews_exist(pagereviews)
		pagereviews.count > 0
	end

	def parse_review(app_id, storename, raw_review)
		app = App.find(app_id)
		strings 	= (raw_review/:SetFontStyle)
    meta    	= strings[2].inner_text.split(/\n/).map { |x| x.strip }
    uri_regex = /https[^\"]*/i
    reviewitunesid = raw_review.inner_html.match(/userReviewId=\d+/).to_s[13..-1].to_i

    if meta.find{|e| /Version/=~e}
    	updated = DateTime.parse(meta[12])
    	version = meta[9][/Version (.*)/, 1]
    else
    	logger.info "Anomalous Review Found - no Version Exists. Using alternate Date and populating Version with none."
    	logger.info "Strings for review: #{strings}"
    	updated = DateTime.parse(meta[9])
    	version = "none"
    end

    if app.reviews.find_by(itunesid: reviewitunesid).nil?
			review = app.reviews.create(updated: 		updated,
				        									title: 			strings[0].inner_text.strip,
				        									content: 		strings[3].inner_html.gsub("<br />", " ").gsub("&#39;", "\'").gsub("&#34;", "\"").gsub("&amp;", "&").strip,
				        									rating: 		raw_review.inner_html.match(/alt="(\d+) star(s?)"/)[1].to_i,
				        									author: 		meta[4],
				        									version: 		version,
				        									author_uri: uri_regex.match(strings[2].inner_html).to_s,
				        									store: 			storename,
				        									itunesid: 	reviewitunesid)
			if review.save
				update_app_store_version_lists(app_id, review.store, review.version)
			else
	    	logger.error "There has been a review building error: "
	    	logger.error review.errors.full_messages
	    end
	  end
	end

	def update_app_store_version_lists(app_id, store, version)
		app = App.find(app_id)
		app.store_list_will_change!
		app.version_list_will_change!
		app.store_list << store unless app.store_list.include?(store)
		app.version_list << version unless app.version_list.include?(version)
		app.save
	end


	### URL-building methods
	def fetch(url, headers={})
		HTTParty.get(url, :headers => headers)
	end

	def base_uri
		"https://itunes.apple.com"
	end

	def parse_xml(response)
		Hpricot.XML(response)
	end

	def genre(ranking_group_genre)
		"/genre=#{ranking_group_genre}" unless ranking_group_genre.nil?
	end



	RANKING_GROUPS = [
		{ :name => "topfree", 		 					:itunes_name => 'topfreeapplications', :genre_id => nil },
		{ :name => "topfreebooks", 					:itunes_name => 'topfreeapplications', :genre_id => '6018' },
		{ :name => "topfreebusiness", 			:itunes_name => 'topfreeapplications', :genre_id => '6000' },
		{ :name => "topfreecatalogs", 			:itunes_name => 'topfreeapplications', :genre_id => '6022' },
		{ :name => "topfreeeducation", 			:itunes_name => 'topfreeapplications', :genre_id => '6017' },
		{ :name => "topfreeentertainment", 	:itunes_name => 'topfreeapplications', :genre_id => '6016' },
		{ :name => "topfreefinance", 				:itunes_name => 'topfreeapplications', :genre_id => '6015' },
		{ :name => "topfreefood", 					:itunes_name => 'topfreeapplications', :genre_id => '6023' },
		{ :name => "topfreegames", 					:itunes_name => 'topfreeapplications', :genre_id => '6014' },
		{ :name => "topfreehealth", 				:itunes_name => 'topfreeapplications', :genre_id => '6013' },
		{ :name => "topfreelifestyle", 			:itunes_name => 'topfreeapplications', :genre_id => '6012' },
		{ :name => "topfreemedical", 				:itunes_name => 'topfreeapplications', :genre_id => '6020' },
		{ :name => "topfreemusic", 					:itunes_name => 'topfreeapplications', :genre_id => '6011' },
		{ :name => "topfreenavigation", 		:itunes_name => 'topfreeapplications', :genre_id => '6010' },
		{ :name => "topfreenews", 					:itunes_name => 'topfreeapplications', :genre_id => '6009' },
		{ :name => "topfreenewsstand", 			:itunes_name => 'topfreeapplications', :genre_id => '6021' },
		{ :name => "topfreephotovideo", 		:itunes_name => 'topfreeapplications', :genre_id => '6008' },
		{ :name => "topfreeproductivity", 	:itunes_name => 'topfreeapplications', :genre_id => '6007' },
		{ :name => "topfreereference", 			:itunes_name => 'topfreeapplications', :genre_id => '6006' },
		{ :name => "topfreesocial", 				:itunes_name => 'topfreeapplications', :genre_id => '6005' },
		{ :name => "topfreesports", 				:itunes_name => 'topfreeapplications', :genre_id => '6004' },
		{ :name => "topfreetravel", 				:itunes_name => 'topfreeapplications', :genre_id => '6003' },
		{ :name => "topfreeutilities", 			:itunes_name => 'topfreeapplications', :genre_id => '6002' },
		{ :name => "topfreeweather", 				:itunes_name => 'topfreeapplications', :genre_id => '6001' },

		{ :name => "toppaid", 							:itunes_name => 'toppaidapplications', :genre_id => nil },
		{ :name => "toppaidbooks", 					:itunes_name => 'toppaidapplications', :genre_id => '6018' },
		{ :name => "toppaidbusiness", 			:itunes_name => 'toppaidapplications', :genre_id => '6000' },
		{ :name => "toppaidcatalogs", 			:itunes_name => 'toppaidapplications', :genre_id => '6022' },
		{ :name => "toppaideducation", 			:itunes_name => 'toppaidapplications', :genre_id => '6017' },
		{ :name => "toppaidentertainment", 	:itunes_name => 'toppaidapplications', :genre_id => '6016' },
		{ :name => "toppaidfinance", 				:itunes_name => 'toppaidapplications', :genre_id => '6015' },
		{ :name => "toppaidfood", 					:itunes_name => 'toppaidapplications', :genre_id => '6023' },
		{ :name => "toppaidgames", 					:itunes_name => 'toppaidapplications', :genre_id => '6014' },
		{ :name => "toppaidhealth", 				:itunes_name => 'toppaidapplications', :genre_id => '6013' },
		{ :name => "toppaidlifestyle", 			:itunes_name => 'toppaidapplications', :genre_id => '6012' },
		{ :name => "toppaidmedical", 				:itunes_name => 'toppaidapplications', :genre_id => '6020' },
		{ :name => "toppaidmusic", 					:itunes_name => 'toppaidapplications', :genre_id => '6011' },
		{ :name => "toppaidnavigation", 		:itunes_name => 'toppaidapplications', :genre_id => '6010' },
		{ :name => "toppaidnews", 					:itunes_name => 'toppaidapplications', :genre_id => '6009' },
		{ :name => "toppaidnewsstand", 			:itunes_name => 'toppaidapplications', :genre_id => '6021' },
		{ :name => "toppaidphotovideo", 		:itunes_name => 'toppaidapplications', :genre_id => '6008' },
		{ :name => "toppaidproductivity", 	:itunes_name => 'toppaidapplications', :genre_id => '6007' },
		{ :name => "toppaidreference", 			:itunes_name => 'toppaidapplications', :genre_id => '6006' },
		{ :name => "toppaidsocial", 				:itunes_name => 'toppaidapplications', :genre_id => '6005' },
		{ :name => "toppaidsports", 				:itunes_name => 'toppaidapplications', :genre_id => '6004' },
		{ :name => "toppaidtravel", 				:itunes_name => 'toppaidapplications', :genre_id => '6003' },
		{ :name => "toppaidutilities", 			:itunes_name => 'toppaidapplications', :genre_id => '6002' },
		{ :name => "toppaidweather", 				:itunes_name => 'toppaidapplications', :genre_id => '6001' },
	]

	STORES = [
	  { :name => 'United States',        :id => 143441, :language => 'en',			:rss_name => 'us'},
	  { :name => 'Australia',            :id => 143460, :language => 'en',    	:rss_name => 'au'},
	  { :name => 'Canada',               :id => 143455, :language => 'en',    	:rss_name => 'ca'},
	  { :name => 'United Kingdom',       :id => 143444, :language => 'en',    	:rss_name => 'gb'},
	]

end
