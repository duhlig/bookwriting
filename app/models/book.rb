class Book < ActiveRecord::Base
  attr_accessible :text, :title, :abstract, :original_updated_at
  validates :title, :presence => true
  validates :text, :presence => true

  has_many :authorships, :dependent => :destroy
  has_many :users, :through => :authorships

  has_paper_trail :on => [:update, :destroy]

  validate :handle_conflict, only: :update

  def original_updated_at
    @original_updated_at || updated_at.to_f
  end
  attr_writer :original_updated_at

  def handle_conflict
    if @conflict || updated_at.to_f > original_updated_at.to_f
      @conflict = true
      @original_updated_at = nil
      errors.add :base, "This record changed while you were editing. Take these changes into account and submit it again."
      changes.each do |attribute, values|
        errors.add attribute, "was #{values.first}"
      end
    end
  end

  def author_names
    self.users.map { |u| u.name }
  end
end
