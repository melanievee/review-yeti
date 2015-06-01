class PopulateRankchangeInRanking < ActiveRecord::Migration
  def change
  	Ranking.where("pulldate > ?", 1.day.ago).each do |ranking|
  		time_in_hours = 12
  		timemargin = 2
			rank12ago = Ranking.find_by_sql("SELECT * FROM rankings WHERE (app_id = '#{ranking.app_id}' 
				AND category = '#{ranking.category}' 
				AND store = '#{ranking.store}' 
				AND pulldate > '#{ranking.pulldate-time_in_hours.hours-timemargin.hours}' 
				AND pulldate < '#{ranking.pulldate-time_in_hours.hours+timemargin.hours}') 
			  ORDER BY ABS(extract(epoch from (pulldate-'#{ranking.pulldate-time_in_hours.hours}')))").first.try(:rank) || nil
			ranking.change12hr = (rank12ago - ranking.rank) unless rank12ago.nil?

			time_in_hours = 24
  		rank24ago = Ranking.find_by_sql("SELECT * FROM rankings WHERE (app_id = '#{ranking.app_id}' 
				AND category = '#{ranking.category}' 
				AND store = '#{ranking.store}' 
				AND pulldate > '#{ranking.pulldate-time_in_hours.hours-timemargin.hours}' 
				AND pulldate < '#{ranking.pulldate-time_in_hours.hours+timemargin.hours}') 
			  ORDER BY ABS(extract(epoch from (pulldate-'#{ranking.pulldate-time_in_hours.hours}')))").first.try(:rank) || nil
			ranking.change24hr = (rank24ago - ranking.rank) unless rank24ago.nil?

			ranking.save
  	end
  end
end
