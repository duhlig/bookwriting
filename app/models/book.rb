class Book < ActiveRecord::Base
  attr_accessible :text, :title, :abstract, :original_updated_at
  validates :title, :presence => true
  validates :text, :presence => true
  validate :handle_conflict, only: :update

  #
  # optimistic locking:
  # manual refresh of the updated_at time is needed
  # to allow continuous editing by the same user
  #
  after_create :refresh_original_updated_at
  after_update :refresh_original_updated_at

  # on book deletion, delete all corresponding authorships
  has_many :authorships, :dependent => :destroy
  has_many :users, :through => :authorships

  # versioning through paper trail
  has_paper_trail :on => [:update, :destroy]

  def original_updated_at
    @original_updated_at || updated_at.to_f
  end
  attr_writer :original_updated_at

  def refresh_original_updated_at
	  @original_updated_at = updated_at.to_f
  end

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

  def user_authorship(user)
    Authorship.where(book_id: self.id, user_id: user.id).first
  end

  def version_num
    Version.where(item_id: self.id, item_type: 'Book').count + 1
  end
end
