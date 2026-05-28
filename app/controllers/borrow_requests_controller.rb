class BorrowRequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    @incoming_requests = current_user.incoming_borrow_requests
    @outgoing_requests = current_user.outgoing_borrow_requests

    render({ :template => "borrow_request_templates/index" })
  end

  def create_row
    the_book_id = params.fetch("path_book_id")
    @book = Book.where({ :id => the_book_id }).at(0)

    if @book == nil
      redirect_to("/books", { :alert => "Book not found." })
    elsif @book.user_id == current_user.id
      redirect_to("/books/" + @book.id.to_s, { :alert => "You cannot request your own book." })
    else
      @borrow_request = BorrowRequest.new
      @borrow_request.requester_id = current_user.id
      @borrow_request.owner_id = @book.user_id
      @borrow_request.book_id = @book.id
      @borrow_request.status = "pending"
      @borrow_request.message = params.fetch("query_message")

      if @borrow_request.save
        redirect_to("/books/" + @book.id.to_s, { :notice => "Borrow request sent." })
      else
        redirect_to("/books/" + @book.id.to_s, { :alert => @borrow_request.errors.full_messages.join(", ") })
      end
    end
  end

  def approve
    the_id = params.fetch("path_id")
    @borrow_request = BorrowRequest.where({ :id => the_id }).at(0)

    if @borrow_request != nil && @borrow_request.owner_id == current_user.id && @borrow_request.status == "pending"
      @borrow_request.status = "approved"
      @borrow_request.save
    end

    redirect_to("/borrow_requests")
  end

  def deny
    the_id = params.fetch("path_id")
    @borrow_request = BorrowRequest.where({ :id => the_id }).at(0)

    if @borrow_request != nil && @borrow_request.owner_id == current_user.id && @borrow_request.status == "pending"
      @borrow_request.status = "denied"
      @borrow_request.save
    end

    redirect_to("/borrow_requests")
  end
end
