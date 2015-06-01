require 'rails_helper'

describe "Static pages" do

	let(:base_title) { "Review Yeti" }
	subject { page }

  shared_examples_for "all static pages" do 
  	it { should have_selector('h1', text: heading) }
  	it { should have_title(full_title(page_title)) }
  end

  shared_examples_for "all ranking pages" do
    it { should have_selector('h3', text: rankings_heading) }
  end

  describe "Home page" do
  	before { visit root_path }
  	let(:heading) { 'Review Yeti' }
  	let(:page_title) { '' }

  	it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }

    describe "for signed-in users" do 
      let(:user) { FactoryGirl.create(:user) }
      before do 
        sign_in user
        visit root_path
      end

      it "should render the user's profile page" do 
        expect(page).to have_title(full_title('Profile') )
      end
    end
  end

  describe "Features page" do
    before { visit features_path }
  	let(:heading) { 'Features' }
  	let(:page_title) { 'Features' }

  	it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
  	let(:heading) { 'Contact' }
  	let(:page_title) { 'Contact' }

  	it_should_behave_like "all static pages"
  end

  describe "Top Free Rankings page" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Free' }
    let(:category) { 'topfree' }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      visit rankings_path(category: category, genre: nil)
    end
    
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"

    it "should not show all rankings for non signed-in users" do
      expect(page).to have_selector('table tr', :count => 6)
    end

    it { should have_content('Please sign in or sign up to view more rankings') }

    describe "for signed-in users" do 
      let(:user) { FactoryGirl.create(:user) }
      before do 
        sign_in user
        visit rankings_path(category: category, genre: nil)
      end

      it "should render the full Top Free Rankings page" do 
        expect(page).to have_selector('tr', :count => 201)
      end
      it_should_behave_like "all static pages"
      it_should_behave_like "all ranking pages"
    end
  end

  describe "Top Free Books Rankings page for signed-in users" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Free Books' }
    let(:category) { 'topfreebooks' }
    let(:user) { FactoryGirl.create(:user) }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      sign_in user
      visit rankings_path(category: category[0..6], genre: category[7..-1])
    end
    it "should render the full rankings page" do 
      expect(page).to have_selector('tr', :count => 201)
    end
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"
  end

  describe "Top Free Business Rankings page for signed-in users" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Free Business' }
    let(:category) { 'topfreebusiness' }
    let(:user) { FactoryGirl.create(:user) }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      sign_in user
      visit rankings_path(category: category[0..6], genre: category[7..-1])
    end
    it "should render the full rankings page" do 
      expect(page).to have_selector('tr', :count => 201)
    end
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"
  end

  describe "Top Free Catalogs Rankings page for signed-in users" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Free Catalogs' }
    let(:category) { 'topfreecatalogs' }
    let(:user) { FactoryGirl.create(:user) }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      sign_in user
      visit rankings_path(category: category[0..6], genre: category[7..-1])
    end
    it "should render the full rankings page" do 
      expect(page).to have_selector('tr', :count => 201)
    end
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"
  end

  describe "Top Free Education Rankings page for signed-in users" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Free Education' }
    let(:category) { 'topfreeeducation' }
    let(:user) { FactoryGirl.create(:user) }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      sign_in user
      visit rankings_path(category: category[0..6], genre: category[7..-1])
    end
    it "should render the full rankings page" do 
      expect(page).to have_selector('tr', :count => 201)
    end
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"
  end

  describe "Top Free Entertainment Rankings page for signed-in users" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Free Entertainment' }
    let(:category) { 'topfreeentertainment' }
    let(:user) { FactoryGirl.create(:user) }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      sign_in user
      visit rankings_path(category: category[0..6], genre: category[7..-1])
    end
    it "should render the full rankings page" do 
      expect(page).to have_selector('tr', :count => 201)
    end
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"
  end

  describe "Top Free Finance Rankings page for signed-in users" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Free Finance' }
    let(:category) { 'topfreefinance' }
    let(:user) { FactoryGirl.create(:user) }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      sign_in user
      visit rankings_path(category: category[0..6], genre: category[7..-1])
    end
    it "should render the full rankings page" do 
      expect(page).to have_selector('tr', :count => 201)
    end
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"
  end

  describe "Top Free Food Rankings page for signed-in users" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Free Food' }
    let(:category) { 'topfreefood' }
    let(:user) { FactoryGirl.create(:user) }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      sign_in user
      visit rankings_path(category: category[0..6], genre: category[7..-1])
    end
    it "should render the full rankings page" do 
      expect(page).to have_selector('tr', :count => 201)
    end
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"
  end

  describe "Top Free Games Rankings page for signed-in users" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Free Games' }
    let(:category) { 'topfreegames' }
    let(:user) { FactoryGirl.create(:user) }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      sign_in user
      visit rankings_path(category: category[0..6], genre: category[7..-1])
    end
    it "should render the full rankings page" do 
      expect(page).to have_selector('tr', :count => 201)
    end
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"
  end

  describe "Top Free Health Rankings page for signed-in users" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Free Health' }
    let(:category) { 'topfreehealth' }
    let(:user) { FactoryGirl.create(:user) }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      sign_in user
      visit rankings_path(category: category[0..6], genre: category[7..-1])
    end
    it "should render the full rankings page" do 
      expect(page).to have_selector('tr', :count => 201)
    end
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"
  end

  describe "Top Free Lifestyle Rankings page for signed-in users" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Free Lifestyle' }
    let(:category) { 'topfreelifestyle' }
    let(:user) { FactoryGirl.create(:user) }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      sign_in user
      visit rankings_path(category: category[0..6], genre: category[7..-1])
    end
    it "should render the full rankings page" do 
      expect(page).to have_selector('tr', :count => 201)
    end
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"
  end

  describe "Top Free Medical Rankings page for signed-in users" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Free Medical' }
    let(:category) { 'topfreemedical' }
    let(:user) { FactoryGirl.create(:user) }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      sign_in user
      visit rankings_path(category: category[0..6], genre: category[7..-1])
    end
    it "should render the full rankings page" do 
      expect(page).to have_selector('tr', :count => 201)
    end
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"
  end

  describe "Top Free Music Rankings page for signed-in users" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Free Music' }
    let(:category) { 'topfreemusic' }
    let(:user) { FactoryGirl.create(:user) }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      sign_in user
      visit rankings_path(category: category[0..6], genre: category[7..-1])
    end
    it "should render the full rankings page" do 
      expect(page).to have_selector('tr', :count => 201)
    end
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"
  end

  describe "Top Free Navigation Rankings page for signed-in users" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Free Navigation' }
    let(:category) { 'topfreenavigation' }
    let(:user) { FactoryGirl.create(:user) }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      sign_in user
      visit rankings_path(category: category[0..6], genre: category[7..-1])
    end
    it "should render the full rankings page" do 
      expect(page).to have_selector('tr', :count => 201)
    end
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"
  end

  describe "Top Free News Rankings page for signed-in users" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Free News' }
    let(:category) { 'topfreenews' }
    let(:user) { FactoryGirl.create(:user) }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      sign_in user
      visit rankings_path(category: category[0..6], genre: category[7..-1])
    end
    it "should render the full rankings page" do 
      expect(page).to have_selector('tr', :count => 201)
    end
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"
  end

  describe "Top Free Newsstand Rankings page for signed-in users" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Free Newsstand' }
    let(:category) { 'topfreenewsstand' }
    let(:user) { FactoryGirl.create(:user) }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      sign_in user
      visit rankings_path(category: category[0..6], genre: category[7..-1])
    end
    it "should render the full rankings page" do 
      expect(page).to have_selector('tr', :count => 201)
    end
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"
  end

  describe "Top Free Photo/Video Rankings page for signed-in users" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Free Photovideo' }
    let(:category) { 'topfreephotovideo' }
    let(:user) { FactoryGirl.create(:user) }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      sign_in user
      visit rankings_path(category: category[0..6], genre: category[7..-1])
    end
    it "should render the full rankings page" do 
      expect(page).to have_selector('tr', :count => 201)
    end
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"
  end

  describe "Top Free Productivity Rankings page for signed-in users" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Free Productivity' }
    let(:category) { 'topfreeproductivity' }
    let(:user) { FactoryGirl.create(:user) }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      sign_in user
      visit rankings_path(category: category[0..6], genre: category[7..-1])
    end
    it "should render the full rankings page" do 
      expect(page).to have_selector('tr', :count => 201)
    end
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"
  end

  describe "Top Free Reference Rankings page for signed-in users" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Free Reference' }
    let(:category) { 'topfreereference' }
    let(:user) { FactoryGirl.create(:user) }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      sign_in user
      visit rankings_path(category: category[0..6], genre: category[7..-1])
    end
    it "should render the full rankings page" do 
      expect(page).to have_selector('tr', :count => 201)
    end
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"
  end

  describe "Top Free Social Rankings page for signed-in users" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Free Social' }
    let(:category) { 'topfreesocial' }
    let(:user) { FactoryGirl.create(:user) }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      sign_in user
      visit rankings_path(category: category[0..6], genre: category[7..-1])
    end
    it "should render the full rankings page" do 
      expect(page).to have_selector('tr', :count => 201)
    end
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"
  end

  describe "Top Free Sports Rankings page for signed-in users" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Free Sports' }
    let(:category) { 'topfreesports' }
    let(:user) { FactoryGirl.create(:user) }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      sign_in user
      visit rankings_path(category: category[0..6], genre: category[7..-1])
    end
    it "should render the full rankings page" do 
      expect(page).to have_selector('tr', :count => 201)
    end
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"
  end

  describe "Top Free Travel Rankings page for signed-in users" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Free Travel' }
    let(:category) { 'topfreetravel' }
    let(:user) { FactoryGirl.create(:user) }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      sign_in user
      visit rankings_path(category: category[0..6], genre: category[7..-1])
    end
    it "should render the full rankings page" do 
      expect(page).to have_selector('tr', :count => 201)
    end
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"
  end

  describe "Top Free Utilities Rankings page for signed-in users" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Free Utilities' }
    let(:category) { 'topfreeutilities' }
    let(:user) { FactoryGirl.create(:user) }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      sign_in user
      visit rankings_path(category: category[0..6], genre: category[7..-1])
    end
    it "should render the full rankings page" do 
      expect(page).to have_selector('tr', :count => 201)
    end
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"
  end

  describe "Top Free Weather Rankings page for signed-in users" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Free Weather' }
    let(:category) { 'topfreeweather' }
    let(:user) { FactoryGirl.create(:user) }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      sign_in user
      visit rankings_path(category: category[0..6], genre: category[7..-1])
    end
    it "should render the full rankings page" do 
      expect(page).to have_selector('tr', :count => 201)
    end
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"
  end

  describe "Top Paid Rankings page" do
    let(:heading) { 'iOS Application Rankings' }
    let(:page_title) { 'Rankings' }
    let(:rankings_heading) { 'Top Paid' }
    let(:category) { "toppaid" }
    before do
      @app = FactoryGirl.create(:app)
      200.times do | count |
        FactoryGirl.create(:ranking, app: @app, category: category) 
      end
      visit rankings_path(category: category, genre: nil)
    end
    
    it_should_behave_like "all static pages"
    it_should_behave_like "all ranking pages"

    it "should not show all rankings for non signed-in users" do
      expect(page).to have_selector('table tr', :count => 6)
    end

    it { should have_content('Please sign in or sign up to view more rankings') }

    describe "for signed-in users" do 
      let(:user) { FactoryGirl.create(:user) }
      before do 
        sign_in user
        visit rankings_path(category: category, genre: nil)
      end

      it "should render the full Top Paid Rankings page" do 
        expect(page).to have_selector('tr', :count => 201)
      end
      it_should_behave_like "all static pages"
      it_should_behave_like "all ranking pages"
    end
  end

  it "should have the right links on the layout" do 
  	visit root_path
  	click_link "Features"
  	expect(page).to have_title(full_title('Features'))
		click_link "Contact"
		expect(page).to have_title(full_title('Contact'))
		click_link "Home"
		expect(page).to have_title(full_title(''))
		click_link "Sign up"
		expect(page).to have_title(full_title('Sign up'))
		click_link "Review Yeti"
		expect(page).to have_title(full_title(''))
    click_link "Rankings"
    expect(page).to have_title(full_title('Rankings'))
	end
end
