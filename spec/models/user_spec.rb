# == Schema Information
#
# Table name: users
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do

  before(:each) do 
    @attr = {:name => "Example User", :email => "user@example.com"}
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
  
end


