class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, default: false # default: false 参数，添加这个参数后用户默认情况下就不是管理员。
  end
end
