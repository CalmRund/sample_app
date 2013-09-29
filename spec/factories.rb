FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
     
    #创建管理员的工厂方法 
    factory :admin do
	  admin true
    end
  end
end
