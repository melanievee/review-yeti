FactoryGirl.define do
  factory :user do
    name          "Melanie Example"
    email         "melanie@example.com"
    password      "foobar"
    password_confirmation "foobar"
    activated     true
    activated_at  Time.zone.now
  end

  factory :app do 
		itunesid 	"343477741"
		name 			"Button Master Free" 
		artist  	"ALL CAPS APPS, LLC"
    category  "Entertainment"
    last_scraped Time.now
    price     0.0
    currency  "USD"
	end

  factory :ranking do 
    rank      13
    category  "topfree"
    store     "United States"
    pulldate  Time.now
    app
  end
end