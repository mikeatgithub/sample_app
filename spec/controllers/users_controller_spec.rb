require 'spec_helper'

describe UsersController do
  render_views
  
  describe "GET 'show'" do
  
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should be successful" do
      get :show, :id => @user.id        # You may only pass @user and rails will get the id
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector('title', :content => @user.name)
    end
    
    it "should the user's name" do
      get :show, :id => @user
      response.should have_selector('h1', :content => @user.name)
    end
    
    it "should have the user's gravatar image" do
      get :show, :id => @user
      # gravatar = global avatar; 'h1>img' = img tag is inside h1 tag
      response.should have_selector('h1>img', :class => "gravatar")
    end

    it "should have the right URL" do
      get :show, :id => @user
      # 'h1>a' = a tag is inside h1 tag
      response.should have_selector('td>a',
                              :content => user_path(@user), 
                              :href      => user_path(@user))
    end

  end
  
  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Sign up")
    end

  end

end
