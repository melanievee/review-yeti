require 'rails_helper'

describe WorkersHelper do

	let!(:bm_scrape_responsebody) { IO.read(Rails.root.join("spec", "fixtures", "buttonmaster_scrape_responsebody.xml")) }
	let!(:bm_rss_responsebody) { IO.read(Rails.root.join("spec", "fixtures", "buttonmaster_rss_responsebody.xml")) }


	describe "initial scrape parse_single_storefront_page" do
		before do
			@app = FactoryGirl.create(:app)
			parsed_response = parse_xml(bm_scrape_responsebody)
			process_single_storefront_page(parsed_response, @app.id, "United States")
			@review = @app.reviews.first
		end

		it "should create a single review" do
			expect(@app.reviews.count).to eq 1
		end

		it "should parse and save review correctly" do
			expect(@review.app_id).to eq @app.id
			expect(@review.updated).to eq DateTime.parse("Oct 31, 2009")
			expect(@review.title).to eq "Excellent game!"
			expect(@review.content).to eq "I love the competition of getting to the top score. There aren't many scores but I can't wait to keep playing for more to be posted. HIGHLY recommend"
			expect(@review.rating).to eq 5
			expect(@review.version).to eq "1.0.0"
			expect(@review.author).to eq "Falconators"
			expect(@review.author_uri).to eq "https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewUsersUserReviews?userProfileId=42610586"
			expect(@review.store).to eq "United States"
			expect(@review.itunesid).to eq 141304683
		end
	end

	describe "update app reviews via RSS feed" do
		before do
			@app = FactoryGirl.create(:app)
			parsed_response = parse_xml(bm_scrape_responsebody)
			process_single_storefront_page(parsed_response, @app.id, "United States")
			parsed_rss = parse_xml(bm_rss_responsebody)
			process_rss_feed(parsed_rss, @app.id)
			@rss_review = @app.reviews.find_by(itunesid: 1026425099)
		end

		it "should create a new review" do
			expect(@app.reviews.count).to eq 2
		end

		it "should parse and save review correctly" do
			expect(@rss_review.app_id).to eq @app.id
			expect(@rss_review.updated).to eq DateTime.parse("2014-07-11T11:18:00-07:00")
			expect(@rss_review.title).to eq "Good"
			expect(@rss_review.content).to eq "It's a great app! The diy's are helpful and fantastic but every time I try to look for something, the app freezes. Please try to fix this. Overall, it's fantastic!"
			expect(@rss_review.rating).to eq 3
			expect(@rss_review.version).to eq "2.1"
			expect(@rss_review.author).to eq "Bo Chet"
			expect(@rss_review.author_uri).to eq "https://itunes.apple.com/us/reviews/id218436351"
			expect(@rss_review.store).to eq "United States"
			expect(@rss_review.itunesid).to eq 1026425099
		end
	end

	describe "rank change calculations" do
		before do
			@app = FactoryGirl.create(:app)
			@ranking_now = FactoryGirl.create(:ranking, app: @app)
			@ranking_12hrold = FactoryGirl.create(:ranking, app: @app, pulldate: Time.now-12.hours, rank: 10)
			@ranking_24hrold = FactoryGirl.create(:ranking, app: @app, pulldate: Time.now-24.hours, rank: 5)
		end
		it "should correctly calculate 12-hour rank change" do
			expect(change_in_rank(@app.id, @ranking_now.category, @ranking_now.store, @ranking_now.pulldate, @ranking_now.rank, 12)).to eq -3
		end
		it "should correctly calculate 24-hour rank change" do
			expect(change_in_rank(@app.id, @ranking_now.category, @ranking_now.store, @ranking_now.pulldate, @ranking_now.rank, 24)).to eq -8
		end
	end

end
