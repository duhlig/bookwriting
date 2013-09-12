class AuthorshipsController < ApplicationController
  before_filter :authenticate_user!
  before_filter

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

end
