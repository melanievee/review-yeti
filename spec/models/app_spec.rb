require 'rails_helper'

describe App do

  before { @app = FactoryGirl.create(:app) }

  subject { @app }

  it { should respond_to(:itunesid) }
  it { should respond_to(:name) }
  it { should respond_to(:artist) }
  it { should respond_to(:reviews) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }
  it { should respond_to(:category) }
  it { should respond_to(:price) }
  it { should respond_to(:currency) }

  it { should be_valid }

  describe "iTunes ID is not present" do
    before { @app.itunesid = " " }
    it { should_not be_valid }
  end

  describe "name is not present" do
    before { @app.name = " " }
    it { should_not be_valid }
  end

  describe "artist is not present" do
    before { @app.artist = " " }
    it { should_not be_valid }
  end

  describe "category is not present" do
    before { @app.category = " " }
    it { should_not be_valid }
  end

  describe "price is not present" do
    before { @app.price = nil }
    it { should_not be_valid }
  end

  describe "currency is not present" do
    before { @app.currency = " " }
    it { should_not be_valid }
  end

  describe "following" do 
  	let(:user) { FactoryGirl.create(:user) }
  	before do 
  		@app.save 
  		user.follow!(@app)
  	end

  	its(:followers) { should include(user) }
  end
end
