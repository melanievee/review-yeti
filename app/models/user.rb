class User < ActiveRecord::Base
	attr_accessor :remember_token, :activation_token
	before_save :downcase_email
	before_create :create_activation_digest
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_apps, through: :relationships, source: :followedapp
		VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, 
						format: { with: VALID_EMAIL_REGEX }, 
						uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, length: { minimum: 6 }, allow_blank: true
	validates :name, presence: true, length: { maximum: 50 }

	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token 
  	SecureRandom.urlsafe_base64
  end

	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	def authenticated?(attribute, token)
		digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
	end

	def forget
		update_attribute(:remember_digest, nil)
	end

	def following?(app)
		relationships.find_by(followedapp_id: app.id)
	end

	def follow!(app)
		if relationships.find_by(followedapp_id: app.id)
		else
			relationships.create!(followedapp_id: app.id)
		end
	end

	def unfollow!(app)
		relationships.find_by(followedapp_id: app.id).destroy
	end

	def following?(app)
		relationships.find_by(followedapp_id: app.id)
	end

	def activate
		update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
  	UserMailer.account_activation(self).deliver
  end

  def is_beta?
  	self.usertype.eql?("beta")
  end

  def can_follow_more_apps?
  	if self.is_beta?
  		return self.relationships.count < 1
  	else
  		return true
  	end
  end

	private

		def downcase_email
			self.email = email.downcase
		end

		def create_activation_digest
			self.activation_token = User.new_token
			self.activation_digest = User.digest(activation_token)
		end
end
