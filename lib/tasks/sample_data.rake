namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_apps
    make_relationships
  end
end

def make_users
  User.create!(name:     "Example User",
               email:    "example@user.org",
               password: "foobar",
               password_confirmation: "foobar")
  User.create!(name:  "Melanie VanderLugt",
               email: "melanie.vanderlugt@gmail.com",
               password: "foobar",
               password_confirmation: "foobar")
end

def make_apps
  app = App.create!(itunesid:     "343477741", 
                    name:         "Button Master Free", 
                    artist:       "ALL CAPS APPS, LLC",
                    category:     "Entertainment",
                    price:        0.0,
                    currency:     "USD",
                    last_scraped: Time.now)
  app.reviews.build(updated:     DateTime.parse("2011-07-21T16:50:00-07:00"), 
                    title:       "Good", 
                    content:     "This is a great game",
                    rating:      5,
                    version:     "2.0.0",
                    author:      "ILoveeBoobiess",
                    author_uri:  "https://itunes.apple.com/us/reviews/id185418830",
                    store:       "United States")
  app.save
end

def make_relationships
  user = User.first
  user2 = User.second
  app = App.first
  user.follow!(app)
  user2.follow!(app)
end