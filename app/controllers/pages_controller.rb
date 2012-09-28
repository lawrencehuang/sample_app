class PagesController < ApplicationController
  def home
    @title = "Home(家)"
  end

  def contact
    @title = "Contact(聯絡人)"
  end

  def about
    @title = "About(關於)"
  end
end
