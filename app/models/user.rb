class User < ActiveRecord::Base
	has_many :microposts, dependent: :destroy #保证用户的微博在删除用户的同时也会被删除
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy #实现 User 和 Relationship 模型之间 has_many 的关联关系
	has_many :followed_users, through: :relationships, source: :followed #使用 :source 参数，告知 Rails followed_users 数组的来源是 followed 所代表的 id 集合
	has_many :reverse_relationships, foreign_key: "followed_id", #通过反转的关系实现 user.followers		
									 class_name:  "Relationship", #为了实现数据表之间的关联，我们要指定类名
									 dependent:   :destroy
	has_many :followers, through: :reverse_relationships, source: :follower	  
	before_save { self.email = email.downcase }
	before_create :create_remember_token
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, presence: true, 
					  format: { with: VALID_EMAIL_REGEX }, 
					  uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, length: { minimum: 6 }
	
	def feed #动态列表的实现
	  Micropost.from_users_followed_by(self)
	end

	def following?(other_user) #检查一个用户是否关注了另一个用户
	  relationships.find_by(followed_id: other_user.id)	
	end

	def follow!(other_user) #创建关注关联关系
	  relationships.create!(followed_id: other_user.id)
	end

	def unfollow!(other_user)
	  relationships.find_by(followed_id: other_user.id).destroy	
	end
	
	def User.new_remember_token
	  SecureRandom.urlsafe_base64
	end
	
	def User.encrypt(token)
	  Digest::SHA1.hexdigest(token.to_s)
	end

	private
	
	  def create_remember_token
	    self.remember_token = User.encrypt(User.new_remember_token)
	  end
end
