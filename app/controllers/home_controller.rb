class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:logged_out]
  

  def logged_out
  end

  def logged_in
    unless current_user
      render 'home/logged_out'
    end
  end
  
end
