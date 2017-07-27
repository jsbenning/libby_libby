class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:logged_out]
  render :layout => 'landing', only: [:logged_out]

  def logged_out
    if current_user
      redirect_to '/logged_in'
    else
      @books = Book.latest_titles
    end
  end

  def logged_in
  end
  
end
