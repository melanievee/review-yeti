require 'rails_helper'

describe Relationship do 

	let(:follower) { FactoryGirl.create(:user) }
	let(:followedapp) { FactoryGirl.create(:app) }
	let(:relationship) { follower.relationships.build(followedapp_id: followedapp.id) }

	subject { relationship }

	it { should be_valid }

	describe "follower methods" do 
		it { should respond_to(:follower) }
		it { should respond_to(:followedapp) }
		its(:follower) { should eq follower }
		its(:followedapp) { should eq followedapp }
	end

	describe "when followedapp id is not present" do 
		before { relationship.followedapp_id = nil }
		it { should_not be_valid }
	end

	describe "when follower id is not present" do 
		before { relationship.follower_id = nil }
		it { should_not be_valid }
	end
end
