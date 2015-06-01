require 'rails_helper'

describe "UserActivations" do

	subject { page }

	describe "signup" do
		before { visit signup_path }
		let(:submit) { "Create my account" }
		let(:email)  { "user@example.com" }
		let(:name) 	 { "Example User" }
		describe "with valid information" do

			before do
        fill_in "Name",             with: name
        fill_in "Email",            with: email
        fill_in "Password",         with: "foobar"
        fill_in "Confirm Password", with: "foobar"
			end

			it "should create an inactive user" do
				expect { click_button submit }.to change(User, :count).by(1)
        expect(User.last.activated).to eq false 
			end

			describe "after saving the user" do
				before { click_button submit }
				it { should have_title(full_title('')) }
				it { should have_success_message('activate') }
				it { should have_link('Sign in') }
				specify { expect(User.last.activated).to eq false }
				specify { expect(ActionMailer::Base.deliveries.last.to).to eq [email] }
				specify { expect(User.find_by_email(email).activation_digest).not_to eq nil }
			end
		end
	end

	describe "activation" do 
		let(:email)  { "user@example.com" }
		let(:name) 	 { "Example User" }
		before do
      post users_path, :user => {:name => name, 
      													 :email => email,
      													 :password => "foobar", 
      													 :password_confirmation => "foobar" }
		end
		describe "with valid information" do
			let(:user) { assigns(:user) }

			describe "cannot sign in until activated" do 
				before { sign_in(user) }
				it { should have_error_message('Account not activated.') }
				it { should have_title('Sign in') }
			end

			describe "activating the user" do 
				before do 
					visit edit_account_activation_path(user.activation_token, email: email)
				end
				it { should have_content(name) }
				it { should have_success_message('Account activated!') }
				specify { expect(User.last.activated).to eq true }
			end

			describe "attempting to activate with invalid token" do 
				before do 
					visit edit_account_activation_path("invalid token")
				end
				it { should_not have_content(name) }
				it { should_not have_success_message('Account activated!') }
				it { should have_error_message('Invalid activation link') }
				specify { expect(User.last.activated).to eq false }
			end

			describe "attempting to activate with invalid email" do 
				before do 
					visit edit_account_activation_path(user.activation_token, email: "wrong")
				end
				it { should_not have_content(name) }
				it { should_not have_success_message('Account activated!') }
				it { should have_error_message('Invalid activation link') }
				specify { expect(User.last.activated).to eq false }
			end
		end
	end
end
