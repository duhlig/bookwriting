class AuthorshipController < ApplicationController
  def edit
    @authorships = Authorship.find_all_by_book_id(params[:id])
    @authorship = Authorship.new
    user

    respond_to do |format|
      if @book.save
        format.html { render action: "edit", notice: 'Book was successfully created.' }
        format.json { render json: @book, status: :created, location: @book }
      else
        format.html { render action: "new" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end
end
