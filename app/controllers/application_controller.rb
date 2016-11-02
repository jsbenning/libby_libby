class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #helper_method :logged_in_user, :logged_in?

  # def logged_in_user
  #   @current_user ||= User.find_by_id(session[:user])
  # end

  # # def logged_in?
  # #   current_user != nil
  # # end
end
