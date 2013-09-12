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

  def authors
	# self.users.map { |u| {:name => u.name, :hash => u.gravatar_hash } }
	authors = []
	self.users.each do |u|
		authors << { :name => u.name, :gravatar_hash => u.gravatar_hash }
		logger.debug("----> hash: #{u.gravatar_hash}")
	end
	logger.debug(authors)
	authors
  end

  def user_authorship(user)
    Authorship.find_by_book_id_and_user_id(self.id, user.id)
  end

  def edit_authorship_permission?(user)
	  a = user_authorship(user)
	  a.can_invite_authors || a.can_manage_authors || a.can_delete_authors
  end


  def chapter_tree
	headlines = []
	doc = Nokogiri::HTML::Document.parse(self.text)
	doc.xpath('//h1 | //h2 | //h3').each do |h|
		headlines << {:level => h.name, :content => h.content}
	end
	chapter_tree_helper headlines
  end

  private

  def chapter_tree_helper(headlines, level = nil, is_root = true)
    tree = []
    offset = 0
  	headlines.each_with_index do |h, id|
	    if offset > 0
			offset = offset - 1
			next
	    end
	    h = headlines[id]
	    level = h[:level] if level.nil?
	    if h[:level] == level
		    tree << h[:content]
	    elsif is_root && h[:level] < level
			tree << h[:content]
			level = h[:level]
	    elsif h[:level] > level
		    subtree = chapter_tree_helper(headlines[id..-1], h[:level], false)
		    tree << subtree
		    offset = subtree.flatten.length-1
		else
			return tree
	    end
    end
	tree
  end

end
