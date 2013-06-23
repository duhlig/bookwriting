class Book < ActiveRecord::Base
  attr_accessible :text, :title, :abstract

  has_many :authorships, :dependent => :destroy
  has_many :users, :through => :authorships

  has_paper_trail :on => [:update, :destroy]

  def author_names
    self.users.map { |u| u.name }
  end
end
