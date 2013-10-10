module SessionsHelper

	def sign_in(user)
		remember_token = User.new_remember_token
		cookies.permanent[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.encrypt(remember_token))
		self.current_user = user
	end

	def signed_in?
	  !current_user.nil?
	end

	def current_user=(user)
	  @current_user = user
	end

	def current_user 
	  remember_token = User.encrypt(cookies[:remember_token])
	  @current_user ||= User.find_by(remember_token: remember_token)
	end

	def current_user?(user)
	  user == current_user
	end
	
	#我们使用了设定 flash[:notice] 的简便方式，把 redirect_to 方法的第二个参数指定为一个 Hash
    #flash[:error] 也可以使用上述的简便方式，但 flash[:success] 却不可以
	def signed_in_user
	  unless signed_in?
	  	store_location
	  	redirect_to signin_url, notice: "Please sign in."
	  end
	end

	def sign_out
	  self.current_user = nil
	  cookies.delete(:remember_token)
	end

	#实现更友好的转向所需的代码
	def redirect_back_or(default)
	  redirect_to(session[:return_to] || default)
	  session.delete(:return_to) #成功转向后就会删除存储在 session 中的转向地址。如果不删除的话，在关闭浏览器之前，每次登录后都会转到存储的地址上。
	end

	def store_location
	  session[:return_to] = request.fullpath if request.get? #使用了 request 对象的 fullpath 方法获取了所请求页面的完整地址
	end
end
