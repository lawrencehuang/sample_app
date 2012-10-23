require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create!(:name => "Lawrence Huang",
                       :email => "mr.godfather@gmail.com",
                       :password => "welcome",
                       :password_confirmation => "welcome")

  admin.toggle!(:admin)
  99.times do |n|
    name = Faker::Name.name
    email = "sample-#{n+1}@haojai.com"
    password = "password"
    User.create!( :name => name,
                  :email => email,
                  :password => password,
                  :password_confirmation => password)
  end
end

def make_microposts
  User.all(:limit => 66).each do |user|
    50.times do
      user.microposts.create!(:content => Faker::Lorem.sentence(5))
    end
  end
end

def make_relationships
  users = User.all
  user = User.first
  following = users[30..66]
  followers = users[1..30]
  following.each { |followed| user.follow!(followed) }
  followers.each {|follower| follower.follow!(user)}
end
