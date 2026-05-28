class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username, :bio, :profile_picture ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :username, :bio, :profile_picture ])
  end

  def after_sign_in_path_for(resource)
    "/my_profile"
  end

  def after_sign_up_path_for(resource)
    "/my_profile"
  end
end
