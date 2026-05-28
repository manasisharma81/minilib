class BorrowMessagesController < ApplicationController
  before_action :authenticate_user!

  def create_row
    the_borrow_request_id = params.fetch("path_borrow_request_id")
    @borrow_request = BorrowRequest.where({ :id => the_borrow_request_id }).at(0)

    if @borrow_request == nil
      redirect_to("/borrow_requests", { :alert => "Borrow request not found." })
    elsif !current_user_is_participant?
      redirect_to("/borrow_requests", { :alert => "You are not part of that conversation." })
    elsif @borrow_request.status == "closed" || @borrow_request.status == "denied"
      redirect_to("/borrow_requests/" + @borrow_request.id.to_s, { :alert => "Conversation archived." })
    else
      @borrow_message = BorrowMessage.new
      @borrow_message.borrow_request_id = @borrow_request.id
      @borrow_message.user_id = current_user.id
      @borrow_message.body = params.fetch("query_body")

      if @borrow_message.save
        redirect_to("/borrow_requests/" + @borrow_request.id.to_s, { :notice => "Message sent." })
      else
        redirect_to("/borrow_requests/" + @borrow_request.id.to_s, { :alert => @borrow_message.errors.full_messages.join(", ") })
      end
    end
  end

  private

  def current_user_is_participant?
    @borrow_request != nil && (@borrow_request.requester_id == current_user.id || @borrow_request.owner_id == current_user.id)
  end
end
