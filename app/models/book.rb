class Book < ActiveRecord::Base
  attr_accessible :text, :title, :user_id, :abstract

  belongs_to :user
end
