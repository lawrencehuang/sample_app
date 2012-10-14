# By using the symbol ':user', we get Factory Girl to simulate the User model.
require "factory_girl"

FactoryGirl.define do
  factory :user do
    name "Michael Hartl"
    email "mhartl@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end
