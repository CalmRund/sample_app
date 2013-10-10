class Micropost < ActiveRecord::Base
  belongs_to :user

  default_scope -> { order('created_at DESC') } #通过 default_scope 设定微博的排序
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true #对微博 user_id 属性的验证
end
