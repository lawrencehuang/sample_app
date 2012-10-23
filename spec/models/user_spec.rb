# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  encrypted_password :string(255)
#  salt               :string(255)
#

require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :name => "Example User",
              :email => "user@example.com",
              :password => "foo_bar",
              :password_confirmation => "foo_bar" }
  end
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  it "should require a name" do
    noname_user = User.create(@attr.merge(:name=>""))
    noname_user.should_not be_valid
  end
  it "should require a email" do
    noemail_user = User.create(@attr.merge(:email=>""))
    noemail_user.should_not be_valid
  end
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "password validation" do
     it "should require password" do
        User.new(@attr.merge(:password =>"", :password_confirmation => "")).should_not be_valid
     end
    it "should require matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
    end
    it "should reject short password" do
      short = "a"*5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
    it "should reject long password" do
      long = "a"*51
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end

  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    it "should set encrypted password" do
       @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end
    end
    
    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@user[:email], "wrong password")
        wrong_password_user.should be_nil
      end
      it "should return nil for an email with no user " do
        wrong_password_user = User.authenticate("foo@foo.org", @user[:password])
        wrong_password_user.should be_nil
      end
      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end
  end   
    
  describe 'relationships' do
    before(:each) do
      @follower = User.create(@attr)
      @followed = FactoryGirl.create(:user,:email => FactoryGirl.generate(:email))
    end
    it "should have 'relationships' method" do
      @follower.should respond_to(:relationships)
    end
    it "should have 'following' method" do
      @follower.should respond_to(:following)
      @followed.should respond_to(:following)
    end
    it "should have 'reverse_relationships' method" do
      @follower.should respond_to(:reverse_relationships)
    end
    it "should have 'followers' method" do
      @follower.should respond_to(:followers)
      @followed.should respond_to(:followers)
    end
    it "should have a 'following?' method " do
      @follower.should respond_to(:following?)
    end
    it "should have a 'follow!' method " do
      @follower.should respond_to(:follow!)
    end
    it "should follow an user" do
      @follower.follow!(@followed)
      @follower.should be_following(@followed)
    end  
    it "should include the followed in the following array" do
      @follower.follow!(@followed)
      @follower.following.should include(@followed)
    end    
    it "should include follower in the followers array" do
      @follower.follow!(@followed)
      @followed.followers.should include(@follower)
    end
    it "should have an 'unfollow! method'" do
      @follower.should respond_to(:unfollow!)
    end
    it "should unfollow! an user" do
      @follower.follow!(@followed)
      @follower.unfollow!(@followed)
      @follower.should_not be_following(@followed)
    end
  end
end

