class AuthorshipsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :user_has_permission
  before_filter :user_can_manage_authors, :only => [:update]
  before_filter :user_can_invite_authors, :only => [:create]
  before_filter :user_can_delete_authors, :only => [:revoke]

  def edit
	@book = Book.find(params[:id])
	@authorships = Authorship.find_all_by_book_id(params[:id])
	@users = users_without_authorship(params[:id])
  end

  def update
	@book = Book.find(params[:id])
	@authorships = Authorship.find_all_by_book_id(params[:id])

	respond_to do |format|
	  if Authorship.update(params[:authorships].keys, params[:authorships].values)
	    format.html { redirect_to edit_authorships_path(@book), notice: 'Authorships were updated.' }
	    format.json { head :no_content }
	  else
	    format.html { render action: "edit" }
	    format.json { render json: @authorships.errors, status: :unprocessable_entity }
	  end
	end
  end

  # add validation for user email
  def create
	    @book = Book.find(params[:id])
	    # @user = User.find_by_email(params[:authorship][:email])
	    @users = User.all
        @authorship = Authorship.new(params[:authorship])
	    # @authorship.user_id = @user.id
	    @authorship.book_id = @book.id
	    logger.debug(@authorship)

		respond_to do |format|
		  if @authorship.save
		    format.html { redirect_to edit_authorships_path(@book), notice: 'Authorship was created.' }
		    format.json { render json: @authorship, status: :created, location: @authorship }
		  else
		    format.html { render action: "edit" }
		    format.json { render json: @authorship.errors, status: :unprocessable_entity }
		  end
		end
  end

  def revoke
    @authorship = Authorship.find(params[:id])
    if @authorship.user_is_author?(current_user)
      @authorship.destroy
      redirect_to :back, :notice => "Revoked #{@authorship.user.name}s access to #{@authorship.book.title}"
    else
      redirect_to :back, :notice => "No permission"
    end
  end

  private

  def users_without_authorship(book_id)
	authorships = Authorship.find_all_by_book_id(book_id)
	users = User.all
	# todo: refactor to more efficient code
	authorships.each do |a|
		users.each do |u|
			if u.id == a.user_id
				users.delete(u)
			end
		end
	end
	users
  end

  private

  def user_has_permission
    a = current_user_authorship
    if a.nil?
      redirect_to root_path, :notice => "You do not have permission to view this page"
    end
	unless a.can_delete_authors || a.can_manage_authors || a.can_invite_authors
	  redirect_to root_path, :notice => "You do not have permission to view this page"
	end

  end

  private

  def user_can_invite_authors
	  unless current_user_authorship.can_invite_authors
		  redirect_to root_path, :notice => "You do not have permission to edit this book"
	  end
  end

  private

  def user_can_delete_authors
	  unless current_user_authorship.can_delete_authors
		  redirect_to root_path, :notice => "You do not have permission to edit this book"
	  end
  end

  private

  def user_can_manage_authors
	  unless current_user_authorship.can_manage_authors
		  redirect_to root_path, :notice => "You do not have permission to edit this book"
	  end
  end

  private

  def current_user_authorship
	  book = Book.find(params[:id])
	  Authorship.find_by_book_id_and_user_id(book.id, current_user.id)
  end

end
