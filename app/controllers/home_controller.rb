class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:logged_out]
  

  def logged_out
    if current_user
      #redirect_to '/logged_in'
      render 'home/logged_in'
    end
  end

  def logged_in
  end
  
end
