class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
  
  has_many(:microposts, :dependent => :destroy)
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, :presence => true,
                            :length => { :maximum => 50 }

  validates :email, :presence => true,
                            :format => { :with => email_regex },
                            :uniqueness => { :case_sensitive => false } # ":uniqueness => true" is implicit here

  validates :password, :presence => true,
                                  :confirmation => true,
                                  :length => { :within => 6..40 }
  
  #Register a callback method called "encrypt_password"
  before_save :encrypt_password       

  def has_password?(submitted_password)
    self.encrypted_password == encrypt(submitted_password)
  end
  
  def feed
    Micropost.where("user_id = ?", id)
  end
  # ----------------------------------------
  # Ways of writing class method
  # ----------------------------------------
  #
  # def User.authenticate(email, submitted_password)
  #                          OR
  # def self.authenticate(email, submitted_password)
  #                          OR
  #
  class << self
    def authenticate(email, submitted_password)
      user = find_by_email(email)
      
      # return nil if user.nil?
      # return user if user.has_password?(submitted_password)
      #above 2 commented lines dothe same thing as the one line below
      (user && user.has_password?(submitted_password)) ? user : nil      
    end
    
    def authenticate_with_salt(id, cookie_salt)
      user = find_by_id(id)
      (user && user.salt == cookie_salt) ? user : nil
    end
  end
  
  private
    
  def encrypt_password
    self.salt = make_salt if self.new_record?
    self.encrypted_password = encrypt(self.password)
  end
  
  def encrypt(string)
    secure_hash("#{self.salt}--#{string}")
  end
  
  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end
  
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
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

