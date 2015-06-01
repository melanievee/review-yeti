class UserMailer < ActionMailer::Base
  default from: "melanie.vanderlugt@gmail.com"

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Please Confirm your new Review Yeti account"
  end

  def password_reset(user)
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
