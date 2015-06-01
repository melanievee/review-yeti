include WorkersHelper

def full_title(page_title)
  base_title = "Review Yeti"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

RSpec::Matchers.define :have_error_message do |message|
	match do |page|
		expect(page).to have_selector('div.alert.alert-error', text: message)
	end
end

RSpec::Matchers.define :have_success_message do |message|
	match do |page|
		expect(page).to have_selector('div.alert.alert-success', text: message)
	end
end

def sign_in(user, options = {})
	if options[:no_capybara]
		#Sign in when not using Capybara.
		# remember_token = User.new_remember_token
		# cookies[:remember_token] = remember_token
		# user.update_attribute(:remember_token, User.digest(remember_token))

		session[:user_id] = user.id

		# post signin_path, :email => user.email, :password => user.password

	else
		visit signin_path
		fill_in "Email", with: user.email.upcase
		fill_in "Password", with: user.password
		click_button "Sign in"
	end
end

def process_rss_feed(rss_response, app_id)
  app = App.find(app_id)
  reviews = rss_response.search("feed > entry")
  reviews.each do |review|
    if review.search("author").any?
      reviewitunesid = review.search("id").inner_text.to_i
      if app.reviews.find_by(itunesid: reviewitunesid).nil?
        newreview = app.reviews.create(updated:     DateTime.parse(review.search("updated").inner_text),
                                        title:      review.search("title").inner_text,
                                        content:    review.search("content").first.inner_text.gsub("\r"," ").gsub("&#39;", "\'").gsub("&#34;", "\"").gsub("&amp;", "&").strip, #Add translation later
                                        rating:     review.search("im:rating").inner_text.to_i,
                                        author:     review.search("author > name").inner_text,
                                        version:    review.search("im:version").inner_text,
                                        author_uri: review.search("author > uri").inner_text,
                                        store:      "United States",
                                        itunesid:   reviewitunesid)
        if newreview.save
          update_app_store_version_lists(app_id, newreview.store, newreview.version)
        else
          logger.info "THERE HAS BEEN A REVIEW BUILDING ERROR: "
          logger.info review.errors.full_messages
        end
      end
    end
  end
end
