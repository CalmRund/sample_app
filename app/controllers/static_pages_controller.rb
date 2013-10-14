class StaticPagesController < ApplicationController
  
  #定义了可分页动态列表的 home 动作
  def home 
  	if signed_in?
	    @micropost  = current_user.microposts.build 
	    @feed_items = current_user.feed.paginate(page: params[:page])
	  end
  end

  def help
  end

  def about
  end

  def contact
  end
end
