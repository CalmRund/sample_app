include ApplicationHelper

#添加一个帮助函数和一个 RSpec 自定义匹配器
def valid_signin(user)
	fill_in "Email", with: user.email 
	fill_in "Password", with: user.password 
	click_button "Sign in"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
  	expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end

#使用 sign_in 帮助方法，这个方法的作用是访问登录页面，提交合法的表单数据
def sign_in(user, options={})
  if options[:no_capybara]
  	#Sign in when not using Capybara.
  	remember_token = User.new_remember_token
  	cookies[:remember_token] = remember_token
  	user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    visit signin_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end