class Review < ActiveRecord::Base
	belongs_to :app 
	default_scope -> { order('updated DESC') }
	validates :app_id, presence: true 
	validates :updated, presence: true 
	# validates :title, presence: true 
	validates :content, presence: true 
	validates :rating, presence: true 
	validates :version, presence: true
	validates :author, presence: true 
	validates :author_uri, presence: true 
	validates :store, presence: true
	validates :itunesid, presence: true
end
