require "net/http"
require "json"
require "uri"

class BooksController < ApplicationController
  before_action :authenticate_user!

  def index
    @user_books = current_user.user_books

    render({ :template => "book_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")
    @book = Book.where({ :id => the_id }).at(0)

    if @book == nil
      redirect_to("/books")
    else
      @current_user_book = UserBook.where({ :user_id => current_user.id, :book_id => @book.id }).at(0)

      render({ :template => "book_templates/show" })
    end
  end

  def search_form
    render({ :template => "book_templates/search_form" })
  end

  def search_results
    @query = params.fetch("query_search")
    escaped_query = URI.encode_www_form_component(@query)
    url = "https://www.googleapis.com/books/v1/volumes?q=" + escaped_query

    if ENV["GOOGLE_BOOKS_API_KEY"].present?
      url = url + "&key=" + URI.encode_www_form_component(ENV.fetch("GOOGLE_BOOKS_API_KEY"))
    end

    response = Net::HTTP.get_response(URI(url))
    data = JSON.parse(response.body)

    if response.is_a?(Net::HTTPSuccess)
      @results = data.fetch("items", [])
    else
      google_error = data.fetch("error", {})
      Rails.logger.warn("Google Books search failed: " + response.code.to_s + " " + google_error.fetch("message", "No error message"))
      @results = []
      @error_message = "Google Books search is temporarily unavailable. Please try again later."
    end

    render({ :template => "book_templates/search_results" })
  end

  def preview_google_book
    google_books_id = params.fetch("path_google_books_id")
    @book = find_or_create_google_book(google_books_id)

    if @book == nil
      redirect_to("/search_books", { :alert => "Could not load that book from Google Books. Please try again." })
    else
      redirect_to("/books/" + @book.id.to_s)
    end
  end

  def add_google_book
    google_books_id = params.fetch("path_google_books_id")
    @book = find_or_create_google_book(google_books_id)

    if @book == nil
      redirect_to("/search_books", { :alert => "Could not add that book from Google Books. Please try again." })
      return
    end

    @user_book = UserBook.new
    @user_book.user_id = current_user.id
    @user_book.book_id = @book.id

    if @user_book.save
      redirect_to("/books/" + @book.id.to_s, { :notice => "Book added to your books." })
    else
      redirect_to("/books/" + @book.id.to_s, { :alert => "This book is already in your books." })
    end
  end

  def new_form
    redirect_to("/search_books")
  end

  def create_row
    redirect_to("/search_books")
  end

  def edit_form
    the_id = params.fetch("path_id")
    @user_book = UserBook.where({ :id => the_id }).at(0)

    if @user_book == nil || @user_book.user_id != current_user.id
      redirect_to("/books")
    else
      render({ :template => "book_templates/edit_form" })
    end
  end

  def update_row
    the_id = params.fetch("path_id")
    @user_book = UserBook.where({ :id => the_id }).at(0)

    if @user_book == nil || @user_book.user_id != current_user.id
      redirect_to("/books")
    else
      @user_book.rating = params.fetch("query_rating")
      @user_book.review = params.fetch("query_review")
      @user_book.availability_status = params.fetch("query_availability_status")

      if @user_book.save
        redirect_to("/books/" + @user_book.book_id.to_s, { :notice => "Your ownership and review were updated." })
      else
        render({ :template => "book_templates/edit_form" })
      end
    end
  end

  def destroy_row
    the_id = params.fetch("path_id")
    @user_book = UserBook.where({ :id => the_id }).at(0)

    if @user_book != nil && @user_book.user_id == current_user.id
      @user_book.destroy
    end

    redirect_to("/books", { :notice => "Book removed from my books." })
  end

  private

  def find_or_create_google_book(google_books_id)
    @book = Book.where({ :google_books_id => google_books_id }).at(0)
    return @book if @book != nil

    data = fetch_google_volume_data(google_books_id)
    return nil if data == nil

    volume_info = data.fetch("volumeInfo", {})

    @book = Book.new
    @book.google_books_id = google_books_id
    @book.title = volume_info.fetch("title", "Untitled")
    @book.authors = volume_info.fetch("authors", []).join(", ")
    @book.description = volume_info.fetch("description", "")
    @book.published_date = volume_info.fetch("publishedDate", "")
    @book.publisher = volume_info.fetch("publisher", "")

    image_links = volume_info.fetch("imageLinks", {})
    @book.cover_image_url = image_links.fetch("thumbnail", "")

    identifiers = volume_info.fetch("industryIdentifiers", [])
    identifiers.each do |identifier|
      if identifier.fetch("type", "") == "ISBN_10"
        @book.isbn_10 = identifier.fetch("identifier", "")
      elsif identifier.fetch("type", "") == "ISBN_13"
        @book.isbn_13 = identifier.fetch("identifier", "")
      end
    end

    @book.save
    @book
  end

  def fetch_google_volume_data(google_books_id)
    url = "https://www.googleapis.com/books/v1/volumes/" + URI.encode_www_form_component(google_books_id)

    if ENV["GOOGLE_BOOKS_API_KEY"].present?
      url = url + "?key=" + URI.encode_www_form_component(ENV.fetch("GOOGLE_BOOKS_API_KEY"))
    end

    response = Net::HTTP.get_response(URI(url))
    data = JSON.parse(response.body)

    unless response.is_a?(Net::HTTPSuccess)
      google_error = data.fetch("error", {})
      Rails.logger.warn("Google Books volume fetch failed: " + response.code.to_s + " " + google_error.fetch("message", "No error message"))
      return nil
    end

    data
  end
end
