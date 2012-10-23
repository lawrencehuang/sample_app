# By using the symbol ':user', we get Factory Girl to simulate the User model.
require "factory_girl"

FactoryGirl.define do
  factory :user do
    name "Factory Girl"
    email "fgirl@factory.com"
    password "password"
    password_confirmation "password"
  end
  FactoryGirl.define do
    sequence :email do |n|
      "factory#{n}@factory.com"
    end
  end
end
