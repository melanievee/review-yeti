require 'rails_helper'

describe "User pages" do 

	subject { page } 

	describe "profile page" do
    let!(:user) { FactoryGirl.create(:user) }

    before do 
      sign_in user
      visit user_path(user)
    end

    it { should have_content(user.name) }
    it { should have_title(full_title('Profile')) }

    describe "followed" do 
      before do 
        @app = FactoryGirl.create(:app)
        @app.save
        user.follow!(@app)
        visit user_path(user)
      end

      it { should have_link('Unfollow', href: relationship_path(user.relationships.first)) }
      it { should have_content(@app.name) }

      describe "unfollowing an app" do 
        it "should decrement the user's followed apps count" do 
          expect do 
            click_link('Unfollow')
          end.to change(user.followed_apps, :count).by(-1)
        end

        describe "clicking Unfollow link" do 
          before do 
            click_link('Unfollow')
            visit user_path(user)
          end
          it { should_not have_content(@app.name) }
          it { should have_content('You are not currently following any apps.') }
        end
      end
    end
  end

	describe "signup page" do 
		before { visit signup_path }

		it { should have_selector('h1', text: 'Sign up') }
		it { should have_title(full_title('Sign up')) }
	end

	describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
				before { click_button submit }

				it { should have_title('Sign up') }
				it { should have_content('error') }
				it { should have_error_message('error') }
			end
    end

    describe "with valid information" do
      before do
        fill_in "Name",             with: "Example User"
        fill_in "Email",            with: "user@example.com"
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
			end
    end
  end

  describe "edit" do 
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do 
      it { should have_content("Update your profile") }
      it { should have_title(full_title("Edit user")) }
      it { should have_link('Change profile photo', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do 
      before do  
        fill_in "Password", with: "a"
        click_button "Save changes"
      end
      it { should have_content('error') }
    end

    describe "with valid information" do 
      let(:new_email) { "new@example.com" }
      let(:new_name)  { "NewExample User" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password 
        click_button "Save changes"
      end

      it { should have_title('Profile') }
      it { should have_success_message('Your profile has been updated.') }
      it { should have_link('Sign out', href: signout_path) }
      it { should have_content(new_name) }
      specify { expect(user.reload.email).to eq new_email }
      specify { expect(user.reload.name).to eq new_name }
    end
  end
end
