class UsersController < ApplicationController
	before_action :signed_in_user,  only: [:edit, :update, :show]
  before_action :correct_user,    only: [:edit, :update, :show]

  def show
    @apps = @user.followed_apps
	end

  def new
    if signed_in?
      redirect_to(root_url)
    else
      @user = User.new
    end
  end

  def create
    if signed_in?
      redirect_to root_url
    else
    	@user = User.new(user_params)
    	if @user.save
        @user.send_activation_email
    		flash[:success] = "Please check your email to activate your account."
    		redirect_to root_url
    	else
    		render 'new'
    	end
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Your profile has been updated."
      redirect_to profile_path
    else
      render 'edit'
    end
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation, :gets_emails)
  	end

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      if params[:id].nil?
        @user = current_user
      else
        @user = User.find(params[:id])
        if !(current_user?(@user))
          flash[:error] = "Oops!  Looks like you tried to access another user's data.  If you think you've received this message in error, let us know!"
          redirect_to(root_url)
        end
      end
    end
end



