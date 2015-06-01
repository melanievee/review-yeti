require 'rails_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }

    describe "with invalid information" do

  		describe "with invalid email" do
        before { click_button "Sign in" }
        it { should have_title('Sign in') }
        it { should have_error_message('Invalid') }
      end

      describe "after visiting another page" do
  			before { click_button "Sign in" }
        before { click_link "Home" }
  			it {should_not have_error_message }
  		end
  	end

  	describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in(user) }

      it { should have_title('Profile') }
      it { should have_link('Profile',     href: profile_path) }
      it { should have_link('Settings',    href: profile_edit_path) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
        it { should_not have_link('Profile', href: user_path(user)) }
        it { should_not have_link('Settings', href: edit_user_path(user)) }
      end
    end
  end

  describe "authorization" do 
    describe "for non-signed-in users" do 
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do 
        before do 
          visit edit_user_path(user)
          sign_in(user)
        end

        describe "after signing in" do 
          it "should render the desired protected page" do 
            expect(page).to have_title('Edit user')
          end

          describe "when signing in again" do
            before do
              click_link "Sign out"
              sign_in user 
            end

            it "should render the default (profile) page" do
              expect(page).to have_title('Profile')
            end
          end
        end
      end

      describe "in the Users controller" do 
        describe "visiting the edit page" do 
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "visiting the profile page" do 
          before { visit user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do 
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end

      describe "in the Relationships controller" do 
        describe "submitting to the create action" do 
          before { post relationships_path }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do 
          before { delete relationship_path(1) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end

      describe "in the Apps controller" do 
        describe "submitting to the create action" do 
          before { post apps_path }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
    end

    # describe "as signed-in user" do 
    #   let!(:user) { FactoryGirl.create(:user) }
    #   before { sign_in user, no_capybara: true }

    #   describe "submitting a GET request to the Users#new action" do 
    #     before { get new_user_path }
    #     specify { expect(response).to redirect_to(root_url) }
    #   end

    #   describe "submitting a POST request to the Users#create action" do 
    #     before { post users_path }
    #     specify { expect(response).to redirect_to(root_url) }
    #   end
    # end

    # describe "as wrong user (without capybara)" do 
    #   let!(:user) { FactoryGirl.create(:user) }
    #   let!(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
    #   before { sign_in user, no_capybara: true }

    #   describe "submitting a GET request to the Users#edit action" do 
    #     before { get edit_user_path(wrong_user) }
    #     specify { expect(response.body).not_to match(full_title('Edit user')) }
    #     specify { expect(response).to redirect_to(root_url) }
    #   end

    #   describe "submitting a PATCH request to the Users#update action" do 
    #     before { patch user_path(wrong_user) }
    #     specify { expect(response).to redirect_to(root_url) }
    #   end
    # end

    describe "as wrong user (with capybara)" do 
      let!(:user) { FactoryGirl.create(:user) }
      let!(:wrong_user) { FactoryGirl.create(:user, name: "Wrong User", email: "wrong@example.com") }
      before { sign_in wrong_user }

      describe "attempting to view user's profile page" do 
        before { visit user_path(user) }
        it { should have_content(wrong_user.name) }
        it { should_not have_content(user.name) }
        it { should have_error_message('another user\'s data') }
      end
    end
  end
end
