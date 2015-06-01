require "rails_helper"

RSpec.describe UserMailer, :type => :mailer do
  describe "account_activation" do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { UserMailer.account_activation(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Please Confirm your new Review Yeti account")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["melanie.vanderlugt@gmail.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Welcome to Review Yeti!")
      expect(mail.body.encoded).to match(user.name)
      expect(mail.body.encoded).to match(user.activation_token)
      expect(mail.body.encoded).to match(CGI::escape(user.email))
    end
  end

  # describe "password_reset" do
  #   let(:user) { FactoryGirl.create(:user) }
  #   let(:mail) { UserMailer.password_reset(user) }

  #   it "renders the headers" do
  #     expect(mail.subject).to eq("Password reset")
  #     expect(mail.to).to eq(["to@example.org"])
  #     expect(mail.from).to eq(["from@example.com"])
  #   end

  #   it "renders the body" do
  #     expect(mail.body.encoded).to match("Hi")
  #   end
  # end

end
