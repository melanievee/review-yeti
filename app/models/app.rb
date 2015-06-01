class App < ActiveRecord::Base
	has_many :reviews, dependent: :destroy
	has_many :reverse_relationships, foreign_key: "followedapp_id", 
																	 class_name:  "Relationship",
																	 dependent: :destroy
	has_many :followers, through: :reverse_relationships, source: :follower
	has_many :rankings, dependent: :destroy
	validates :itunesid, presence: true
	validates :name, presence: true
	validates :artist, presence: true
	validates :category, presence: true
	validates :price, presence: true
	validates :currency, presence: true

	def itunes_link
		"itms://itunes.apple.com/us/app/id#{itunesid}"
	end
end
