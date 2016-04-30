class User < ActiveRecord::Base
  
  validates_presence_of :username
  validates_uniqueness_of :username
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         :token_authenticatable
         
  has_many :authentication_tokens
end
