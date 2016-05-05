class User < ActiveRecord::Base
  
  
  validates_presence_of :username
  validates_uniqueness_of :username
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         :token_authenticatable
         
  has_many :authentication_tokens
  has_many :posts, :dependent => :destroy
  
  # Follow gem
  acts_as_followable
  acts_as_follower
  
end
