require 'rails_helper'

describe "App pages" do 

	subject { page }

	describe "app show page" do 
		let!(:user) { FactoryGirl.create(:user) }
		
		before do 
			sign_in user
			@app = FactoryGirl.create(:app)
			user.follow!(@app)
			visit app_path(@app) 
		end

		it { should have_content(@app.name) }
		it { should have_title(full_title(@app.name)) }

		describe "reviews" do 
			before do 
				@review1 = @app.reviews.build(updated: DateTime.parse("2011-07-21T16:50:00-07:00"), 
																	 title: 	"Good", 
																	 content: 		"This is a great game",
																	 rating: 			5,
																	 version: 		"2.0.0",
																	 author: 			"ILoveeBoobiess",
																	 author_uri: 	"https://itunes.apple.com/us/reviews/id185418830",
																	 store: 			"United States",
																	 itunesid: 		1023438452)
				@review2 = @app.reviews.build(updated: DateTime.parse("2014-01-21T11:15:00-07:00"), 
																	 title: 	"App Review Number 2", 
																	 content: 		"This is a phenomenal game",
																	 rating: 			4,
																	 version: 		"2.0.0",
																	 author: 			"Reviewnumber2",
																	 author_uri: 	"https://itunes.apple.com/us/reviews/id999999999",
																	 store: 			"United States",
																	 itunesid: 		1023438453)
				@app.save
				visit app_path(@app)
			end

			it { should have_content(@review1.title) }
			it { should have_content(@review2.title) }
		end
	end
end
