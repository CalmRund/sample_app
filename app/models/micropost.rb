class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') } #通过 default_scope 设定微博的排序
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true #对微博 user_id 属性的验证

  # Returns microposts from the users being followed by the given user.
  def self.from_users_followed_by(user)
  	followed_user_ids = "SELECT followed_id FROM relationships
  	                     WHERE follower_id = :user_id" #使用子查询后，所有的集合包含关系都会交由数据库处理，这样性能就得到提升了
  	where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
  		  user_id: user.id)
  end
end
