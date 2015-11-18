FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "smasher#{n}@gmail.com"
    end
    password "omglolhahaha"
    password_confirmation "omglolhahaha"
  end
end