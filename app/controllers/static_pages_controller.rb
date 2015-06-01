class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  		redirect_to profile_path
  	end
  end

  def help
  end

  def features
  end

  def contact
  end

  def rankings
    @category = params[:category] ? params[:category] : "topfree"
    @category_print = @category[0..2].capitalize + " " + @category[3..-1].capitalize
    @genre = params[:genre] ? params[:genre] : ""
    @genre_print = @genre.empty? ? "All" : @genre.capitalize
    ranking_list = @category + @genre
    @ranking_list_print = @category_print + " " + @genre.capitalize
    
    @rankings_us = get_rankings(ranking_list, "United States")
    @rankings_ca = get_rankings(ranking_list, "Canada")
    @rankings_uk = get_rankings(ranking_list, "United Kingdom")
    @rankings_au = get_rankings(ranking_list, "Australia")
  end

  private

    def get_latest_pulldate(category, store)
      Ranking.where("category = ? AND store = ?", category, store).maximum("pulldate")
    end

    def get_rankings(category, store)
      Ranking.where("category = ? AND pulldate = ? AND store = ?", category, get_latest_pulldate(category, store), store).includes(:app)
    end

end
