class UsersController < ApplicationController
  before_action :authenticate_user!

  def show_current_user
    @user = current_user
  end

  def edit_current_user_form
    @user = current_user
  end

  def update_current_user
    @user = current_user

    @user.username = params.fetch("query_username")
    @user.email = params.fetch("query_email")
    @user.bio = params.fetch("query_bio")
    @user.profile_picture = params.fetch("query_profile_picture")

    if @user.save
      redirect_to("/my_profile", { :notice => "Profile updated successfully." })
    else
      render({ :template => "users/edit_current_user_form" })
    end
  end
end
