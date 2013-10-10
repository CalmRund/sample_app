class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy 

  #在 index 动作中按分页取回用户
  def index
    @users = User.paginate(page: params[:page]) #这个 params 元素是由 will_pagenate 自动生成的
  end

  def show
	  @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def create
	  @user = User.new(user_params) 
	  if @user.save
      sign_in @user
		  flash[:success] = "Welcome to the Sample App!"
		  redirect_to @user 
	  else
		  render 'new'
	  end
  end
  
  #既然 correct_user 事前过滤器中已经定义了 @user，这两个动作中就不再需要再定义 @user 变量了。
  def edit
  end
 
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy #把 find 方法和 destroy 方法链在一起使用了
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end	

    # Before filters
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
