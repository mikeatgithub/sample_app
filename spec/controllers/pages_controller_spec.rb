require 'spec_helper'

describe PagesController do

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end
  end

  describe "GET 'contac'" do
    it "should be successful" do
      get 'contac'
      response.should be_success
    end
  end

end
