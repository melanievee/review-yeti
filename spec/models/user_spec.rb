require 'rails_helper'

describe User do

  before { @user = User.new(name: "Example User",
                            email: "user@example.com", 
  													password: "foobar", 
  													password_confirmation: "foobar") }

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:name) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:remember_digest) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_apps) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }
  it { should respond_to(:following?) }
  it { should respond_to(:activation_token) }
  it { should respond_to(:activation_digest) }

  it { should be_valid }

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "when password is not present" do
    before do
      @user = User.new(email: "user@example.com",
                       password: " ", 
                       password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

	describe "return value of authenticate method" do
		before { @user.save }
		let(:found_user) { User.find_by(email: @user.email) }

		describe "with valid password" do
			it { should eq found_user.authenticate(@user.password) }
		end

		describe "with invalid password" do
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }

			it { should_not eq user_for_invalid_password }
			specify { expect(user_for_invalid_password).to be_falsey }
		end
	end

  describe "following" do 
  	let(:app) { FactoryGirl.create(:app) }
  	before do 
  		@user.save
  		@user.follow!(app) 
  	end

  	it { should be_following(app) }
  	its(:followed_apps) { should include(app) }

  	describe "and unfollowing" do 
  		before { @user.unfollow!(app) }

  		it { should_not be_following(app) }
  		its(:followed_apps) { should_not include(app) }
  	end

    it "should destroy associated relationships" do 
      relationships = @user.relationships.to_a
      reverse_relationships = app.reverse_relationships.to_a
      @user.destroy
      expect(relationships).not_to be_empty
      expect(reverse_relationships).not_to be_empty
      relationships.each do |relationship|
        expect(Relationship.where(id: relationship.id)).to be_empty
      end
      reverse_relationships.each do |reverse_relationship|
        expect(Relationship.where(id: reverse_relationship.id)).to be_empty
      end
    end
  end
end