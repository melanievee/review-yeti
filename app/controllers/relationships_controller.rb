class RelationshipsController < ApplicationController
  before_action :signed_in_user
  
  def create
    if current_user.can_follow_more_apps?
      @app = App.find(params[:followedapp_id])
      # If app previously didn't have any followers, it's necessary to launch the iTunes scrape code to populate app's reviews.
      if @app.last_scraped.nil?
        ItunesWorker.perform_async(@app.id)
      end
      current_user.follow!(@app)
      flash[:success] = "Woo hoo!  You are following that App!"
    else
      flash[:error] = "Oops! Don't forget, beta users can only follow one app at a time."
    end
    redirect_to profile_path
  end

  def destroy
    @app = Relationship.find(params[:id]).followedapp
    current_user.unfollow!(@app)
    redirect_to profile_path
  end
end