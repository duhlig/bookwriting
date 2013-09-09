class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:twitter]
  # attr_accessible :title, :body
  attr_accessible :email, :password, :password_confirmation,
                  :name, :remember_me, :provider, :uid

  validates :name, :presence => true

  has_many :authorships, :dependent => :destroy
  has_many :books, :through => :authorships
  has_many :authentications, :dependent => :destroy

end
