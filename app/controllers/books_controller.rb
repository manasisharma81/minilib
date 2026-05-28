class BooksController < ApplicationController
  before_action :authenticate_user!

  def index
    @books = current_user.books

    render({ :template => "book_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")
    @book = Book.where({ :id => the_id }).at(0)

    if @book == nil || @book.user_id != current_user.id
      redirect_to("/books")
    else
      render({ :template => "book_templates/show" })
    end
  end

  def new_form
    @book = Book.new

    render({ :template => "book_templates/new_form" })
  end

  def create_row
    @book = Book.new

    @book.title = params.fetch("query_title")
    @book.author = params.fetch("query_author")
    @book.description = params.fetch("query_description")
    @book.cover_image_url = params.fetch("query_cover_image_url")
    @book.rating = params.fetch("query_rating")
    @book.review = params.fetch("query_review")
    @book.user_id = current_user.id

    if @book.save
      redirect_to("/books", { :notice => "Book created successfully." })
    else
      render({ :template => "book_templates/new_form" })
    end
  end

  def edit_form
    the_id = params.fetch("path_id")
    @book = Book.where({ :id => the_id }).at(0)

    if @book == nil || @book.user_id != current_user.id
      redirect_to("/books")
    else
      render({ :template => "book_templates/edit_form" })
    end
  end

  def update_row
    the_id = params.fetch("path_id")
    @book = Book.where({ :id => the_id }).at(0)

    if @book == nil || @book.user_id != current_user.id
      redirect_to("/books")
    else
      @book.title = params.fetch("query_title")
      @book.author = params.fetch("query_author")
      @book.description = params.fetch("query_description")
      @book.cover_image_url = params.fetch("query_cover_image_url")
      @book.rating = params.fetch("query_rating")
      @book.review = params.fetch("query_review")

      if @book.save
        redirect_to("/books/" + @book.id.to_s, { :notice => "Book updated successfully." })
      else
        render({ :template => "book_templates/edit_form" })
      end
    end
  end

  def destroy_row
    the_id = params.fetch("path_id")
    @book = Book.where({ :id => the_id }).at(0)

    if @book != nil && @book.user_id == current_user.id
      @book.destroy
    end

    redirect_to("/books", { :notice => "Book deleted successfully." })
  end
end
