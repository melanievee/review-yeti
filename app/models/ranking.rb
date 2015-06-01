class Ranking < ActiveRecord::Base
	belongs_to :app
	# default_scope -> { order('rank ASC') }
	validates :app_id, presence: true 
	validates :pulldate, presence: true
	validates :rank, presence: true
	validates :store, presence: true
	validates :category, presence: true

	def self.new_chart_data(app, store)
		rankings = app.rankings.where("store = ?", store).order('pulldate asc')
		rankings.map do |ranking|
			{
				pulldate: ranking.pulldate,
				"#{ranking.category}" => -1*(ranking.rank+1),
				hoverstring: "Rank: #{ranking.rank+1} <br>Pulldate: #{ranking.pulldate.localtime.strftime("%b %e, %l:%M %p")} <br>Category: #{ranking.category}",
			}
		end
	end

	def self.chart_data(app, category, store)
		rankings = app.rankings.where("category = ? AND store = ?", category, store).order('pulldate asc')
		rankings.map do |ranking|
			MorrisRank.new(ranking.rank, ranking.pulldate)
		end
	end
end

class MorrisRank
	attr_accessor :rank, :pulldate, :hoverstring

	def initialize(rank, pulldate)
		@rank = -1*(rank + 1)
		@pulldate = pulldate
		@hoverstring = "Rank: #{rank+1} <br>Pulldate: #{pulldate.strftime("%b %e, %l:%M %p")}"
	end
end