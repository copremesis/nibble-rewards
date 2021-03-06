class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save :ensure_authentication_token!

  has_one :campaign
  has_many :card_holders
  has_one :square_integration

  def ensure_authentication_token!
    
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  private

  #a bit overkill with the loop but if the user doesn't have a token
  #it causes other things to break :-/
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end




end
