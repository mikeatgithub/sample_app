class PagesController < ApplicationController
  
  def index
    @title = 'Index'
  end

  def home
    @title = 'Home'
  end

  def contact
    @title = 'Contact'
  end

  def about
    @title = 'About Us'
  end
end
