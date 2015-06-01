require 'rails_helper'

describe Review do

	let(:app) { FactoryGirl.create(:app) }
  before { @review = app.reviews.build(updated: DateTime.parse("2011-07-21T16:50:00-07:00"), 
																			 title: 	"Good", 
																			 content: 		"This is a great game",
																			 rating: 			5,
																			 version: 		"2.0.0",
																			 author: 			"ILoveeBoobiess",
																			 author_uri: 	"https://itunes.apple.com/us/reviews/id185418830",
                                       store:       "United States",
                                       itunesid:    1023438452)}


  subject { @review }

  it { should respond_to(:updated) }
  it { should respond_to(:title) }
  it { should respond_to(:content) }
  it { should respond_to(:rating) }
  it { should respond_to(:version) }
  it { should respond_to(:author) }
  it { should respond_to(:author_uri) }
  it { should respond_to(:app) }
  it { should respond_to(:store) }
  it { should respond_to(:app_id) }
  it { should respond_to(:itunesid) }
  its(:app) { should eq app }

  it { should be_valid }

  describe "when app_id is not present" do
    before { @review.app_id = nil }
    it { should_not be_valid }
  end

  describe "updated is not present" do
    before { @review.updated = nil }
    it { should_not be_valid }
  end

  describe "itunesid is not present" do
    before { @review.itunesid = nil }
    it { should_not be_valid }
  end

  describe "content is not present" do
    before { @review.content = nil }
    it { should_not be_valid }
  end

  describe "rating is not present" do
    before { @review.rating = nil }
    it { should_not be_valid }
  end

  describe "version is not present" do
    before { @review.version = nil }
    it { should_not be_valid }
  end

  describe "author is not present" do
    before { @review.author = nil }
    it { should_not be_valid }
  end

  describe "author uri is not present" do
    before { @review.author_uri = nil }
    it { should_not be_valid }
  end

  describe "store is not present" do 
    before { @review.store = nil }
    it { should_not be_valid }
  end
end
