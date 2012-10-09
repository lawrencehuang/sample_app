# coding : utf-8
require 'spec_helper'

describe PagesController do
  render_views

  # execute this block before each test
  before(:each) do
    @base_title = "Rails Tutorial Sample App | "
  end

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      response.should be_success
    end
    it "should have the right title" do
      get 'home'
      response.should have_selector("title",
                                    :content => @base_title + "Home(家)")
    end
  end

  describe "GET 'contact'" do
    it "returns http success" do
      get 'contact'
      response.should be_success
    end
    it "should have the right title" do
      get 'contact'
      response.should have_selector("title",
                                    :content => @base_title + "Contact(聯絡人)")
    end
  end

  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      response.should be_success
    end
    it "should have the right title" do
      get 'about'
      response.should have_selector("title",
                                    :content => @base_title + "About(關於)")
    end
  end

end
