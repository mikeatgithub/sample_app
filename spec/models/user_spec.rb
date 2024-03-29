require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
        :name => "Example User",
        :email => "user@example.com",
        :password => "foobar",
        :password_confirmation => "foobar"
    }
  end

  it "should create a new instance given a valid attribute" do
    #   ! at the end of create! means rais an exception if create fails
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should accetp valid email addresses" do
    email_addresses = %w[user@foo.com THE_USER@foo.org first.last@foo.jp]
    
    email_addresses.each do |email_address|
      valid_email_address = User.new(@attr.merge(:email => email_address))
      valid_email_address.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    email_addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    
    email_addresses.each do |email_address|
      invalid_email_address = User.new(@attr.merge(:email => email_address))
      invalid_email_address.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email_addresses = User.new(@attr)
    user_with_duplicate_email_addresses.should_not be_valid
  end

  it "should reject duplicate email addresses ignoring the case" do
    upcased_email_addresses = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email_addresses))
    user_with_duplicate_email_addresses = User.new(@attr)
    user_with_duplicate_email_addresses.should_not be_valid
  end

  describe "passwords" do
  
    before(:each) do
      @user = User.new(@attr)
    end
    
    it "should have a password attribute" do
      @user.should respond_to(:password)
    end
    
    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end

  end
  
  describe "password validation" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
          should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
          should_not be_valid
    end
    
    it "should  reject short passwords" do
      short_password = "a" * 5
      hash = @attr.merge(
          :password => short_password,
          :password_confirmation => short_password)
      User.new(hash).should_not be_valid
    end
    
    it "should  reject long passwords" do
      long_password = "a" * 41
      hash = @attr.merge(
          :password => long_password,
          :password_confirmation => long_password)
      User.new(hash).should_not be_valid
    end
  end

  describe "password encription" do
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end
  
    it "should have salt" do
      @user.should respond_to(:salt)
    end
    
  
    describe "has_password? method" do
    
      it "should exist" do
        @user.should respond_to(:has_password?)
      end
      
      it "should return true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      
      it "should return false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end
    end

    describe "authenticate method" do
    
      it "should exist" do
        User.should respond_to(:authenticate)
      end
      
      it "should return nil on email/password mismatch" do
        User.authenticate(@attr[:email], "wrongpass").should be_nil
      end
      
      it "should return nil for an email address with no user" do
        User.authenticate("bar@foo.com", @attr[:password]).should be_nil
      end

      it "should return the user on email/password match" do
        User.authenticate(@attr[:email], @attr[:password]).should == @user
      end
    end
  end
  
  describe "Admin attribute" do
  
    before(:each) do
      @user = User.create!(@attr)
    end
    
     it "should respond to admin; i.e. user should have admin attribute.  " do
      @user.should respond_to(:admin)
     end
     
     it "should not be admin by default" do
      # The following two lines are identica
      #@user.admin?.should_not be_true 
      @user.should_not be_admin
     end
     
     it "should be convertible to admin" do
      @user.toggle!(:admin)
      @user.should be_admin
     end
  end
  
  describe "micropost associations" do
  
    before(:each) do
      @user = User.create(@attr)
      @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end
    
    it "should have a microposts attribute" do
      @user.should respond_to(:microposts)
    end
    
    it "should have the right microposts in the right order" do
      @user.microposts.should == [@mp2, @mp1]
    end
    
    it "should destroy microposts associated with this user" do
      @user.destroy
      [@mp1, @mp2].each do |micropost|
        # +++++++++++++++++++++++++++++++++++++
        # This commentd line and the following lambda 
        # block do the same things
        # Micropost.find_by_id(micropost.id).should be_nil
        # +++++++++++++++++++++++++++++++++++++
        lambda do
          Micropost.find(micropost)
        end.should raise_error(ActiveRecord::RecordNotFound)
        # +++++++++++++++++++++++++++++++++++++
      end
    end
    
    describe "status feed" do
    
      it "should have a feed" do
        @user.should respond_to(:feed)
      end
      
      it "should include the user's microposts" do
        #@user.feed.include?(@mp1).should be_true
        # Above line can be done better as follows:
        @user.feed.should include(@mp1)
        @user.feed.should include(@mp2)
      end
      
      it "should not include a different user's microposts" do
        mp3 = Factory(:micropost, 
                                :user => Factory(:user, :email => Factory.next(:email)))
        @user.feed.should_not include(mp3)
      end
      
      
    end
  end
end


# == Schema Information
#
# Table name: users
#
#  id                 :integer(4)      not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean(1)      default(FALSE)
#

