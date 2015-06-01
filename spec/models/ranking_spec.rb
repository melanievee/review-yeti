require 'rails_helper'

describe Ranking do

  before do 
  	@app = FactoryGirl.create(:app)
  	@ranking = FactoryGirl.create(:ranking, app: @app) 
  end

  subject { @ranking }

  it { should respond_to(:app_id) }
  it { should respond_to(:rank) }
  it { should respond_to(:pulldate) }
  it { should respond_to(:store) }
  it { should respond_to(:category) }
  it { should respond_to(:app) }

  it { should be_valid }

  describe "app_id is not present" do
    before { @ranking.app_id = " " }
    it { should_not be_valid }
  end

  describe "rank is not present" do
    before { @ranking.rank = nil }
    it { should_not be_valid }
  end

  describe "pulldate is not present" do
    before { @ranking.pulldate = nil }
    it { should_not be_valid }
  end

  describe "store is not present" do
    before { @ranking.store = " " }
    it { should_not be_valid }
  end

  describe "category is not present" do
    before { @ranking.category = " " }
    it { should_not be_valid }
  end

end
