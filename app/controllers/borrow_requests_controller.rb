class BorrowRequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    deleted_statuses = [ "denied", "closed" ]
    @incoming_requests = current_user.incoming_borrow_requests.where.not({ :status => deleted_statuses })
    @outgoing_requests = current_user.outgoing_borrow_requests.where.not({ :status => deleted_statuses })
    @deleted_incoming_requests = current_user.incoming_borrow_requests.where({ :status => deleted_statuses })
    @deleted_outgoing_requests = current_user.outgoing_borrow_requests.where({ :status => deleted_statuses })

    render({ :template => "borrow_request_templates/index" })
  end

  def show
    load_borrow_request_from_params

    if @borrow_request == nil
      redirect_to("/borrow_requests", { :alert => "Borrow request not found." })
    elsif !current_user_is_participant?
      redirect_to("/borrow_requests", { :alert => "You are not part of that conversation." })
    else
      @borrow_messages = @borrow_request.borrow_messages.order(:created_at)
      render({ :template => "borrow_request_templates/show" })
    end
  end

  def create_row
    the_book_id = params.fetch("path_book_id")
    the_owner_id = params.fetch("path_owner_id")
    @book = Book.where({ :id => the_book_id }).at(0)
    @owner = User.where({ :id => the_owner_id }).at(0)

    if @book == nil
      redirect_to("/books", { :alert => "Book not found." })
    elsif @owner == nil
      redirect_to("/books/" + @book.id.to_s, { :alert => "Owner not found." })
    elsif @owner.id == current_user.id
      redirect_to("/books/" + @book.id.to_s, { :alert => "You cannot request your own copy." })
    else
      ownership = UserBook.where({ :user_id => @owner.id, :book_id => @book.id }).at(0)

      if ownership == nil
        redirect_to("/books/" + @book.id.to_s, { :alert => "That user does not own this book." })
      else
        @borrow_request = BorrowRequest.new
        @borrow_request.requester_id = current_user.id
        @borrow_request.owner_id = @owner.id
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

  def close
    load_borrow_request_from_params

    if @borrow_request == nil
      redirect_to("/borrow_requests", { :alert => "Borrow request not found." })
    elsif !current_user_is_participant?
      redirect_to("/borrow_requests", { :alert => "You are not part of that conversation." })
    else
      @borrow_request.status = "closed"
      @borrow_request.save
      redirect_to("/borrow_requests/" + @borrow_request.id.to_s, { :notice => "Conversation closed." })
    end
  end

  private

  def load_borrow_request_from_params
    the_id = params.fetch("path_id")
    @borrow_request = BorrowRequest.where({ :id => the_id }).at(0)
  end

  def current_user_is_participant?
    @borrow_request != nil && (@borrow_request.requester_id == current_user.id || @borrow_request.owner_id == current_user.id)
  end
end
