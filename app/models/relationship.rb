class Relationship < ActiveRecord::Base
	belongs_to :follower, class_name: "User"
	belongs_to :followedapp, class_name: "App"
	validates :follower_id, presence: true 
	validates :followedapp_id, presence: true
end
