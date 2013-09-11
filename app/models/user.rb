class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # attr_accessible :title, :body
  attr_accessible :email, :password, :password_confirmation, :name, :remember_me

  validates :name, :presence => true

  has_many :authorships, :dependent => :destroy
  has_many :books, :through => :authorships

  #
  # generate hash for gravatar image request url
  # usage: <img src="http://www.gravatar.com/avatar/#{hash}"
  #
  def gravatar_hash(user_id = nil)
	  if user_id
		  u = User.find(user_id)
		  email = u.email
	  else
		  email = self.email
	  end
	  email = email.strip.downcase
	  Digest::MD5.hexdigest(email) # return hash
  end

end
