class SessionsController < ApplicationController

	def new
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			if user.activated?
				sign_in user
				if user.is_beta?
					flash[:success] = "Remember, unpaid Beta Users are currently able to follow a single app. If you're chomping at the bit for more apps or more features, visit the Contact page to let us know!"
				end
				params[:session][:remember_me] == '1' ? remember(user) : forget(user)
				redirect_back_or root_url
			else
				message = "Account not activated. "
				message += "Check your email for the activation link."
				flash[:error] = message
				redirect_to signin_url
			end
		else
			flash.now[:error] = 'Invalid email/password combination'
      render 'new'
		end
	end

	def destroy
		sign_out if signed_in?
		redirect_to root_url
	end

end
