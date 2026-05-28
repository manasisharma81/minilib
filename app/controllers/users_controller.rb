class UsersController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [ :show ]

  def show_current_user
    @user = current_user
  end

  def show
    the_id = params.fetch("path_id")
    @user = User.where({ :id => the_id }).at(0)

    if @user == nil
      redirect_to("/")
    else
      render({ :template => "users/show" })
    end
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
