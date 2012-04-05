class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable, :oauthable

  devise :database_authenticatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me


  def display_name
    full_name = "#{first_name} #{last_name}".strip
    full_name = self.email if full_name.blank?    
    full_name
  end
  
  def facebook_avatar_url
    "http://graph.facebook.com/#{self.facebook_id}/picture" if self.facebook_id.present?
  end

  
private
  
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    if user = User.where(:email => data.email).first
      user.update_attribute(:facebook_id, data[:id]) if data[:id].present?
      user
    else # Create a user with a stub password. 
      User.create!(:email => data.email, :password => Devise.friendly_token[0,20]) 
    end
  end 
    
end
