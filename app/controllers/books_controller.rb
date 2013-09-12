class BooksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :user_has_permission, :only => [:show, :edit, :update, :destroy]

  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @book }
      format.pdf {
        render :pdf => 'book',
        :template => 'books/show.pdf.erb'
      }
    end
  end

  # GET /books/new
  # GET /books/new.json
  def new
    @book = Book.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(params[:book])
    @book.users = [ current_user ]

    respond_to do |format|
      if @book.save
		authorship = Authorship.find_by_book_id_and_user_id(@book.id, current_user.id)
		authorship.can_edit_book = true
		authorship.can_delete_authors = true
		authorship.can_invite_authors = true
		authorship.can_manage_authors = true
		authorship.save
        format.html { render action: "edit", notice: 'Book was successfully created.' }
        format.json { render json: @book, status: :created, location: @book }
      else
        format.html { render action: "new" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /books/1
  # PUT /books/1.json
  def update
    @book = Book.find(params[:id])

    respond_to do |format|
      if @book.update_attributes(params[:book])
        format.html { render action: "edit", notice: 'Book was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

  private

  def user_has_permission
    @book = Book.find(params[:id])
    unless Authorship.exists?({:book_id => @book.id, :user_id => current_user.id})
      redirect_to root_path, :notice => "You do not have permission to access this book"
    end
  end
end
