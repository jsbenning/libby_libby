class UsersController < ApplicationController
  require 'pry'
   
  def index
    if current_user.mod_or_admin?
      @users = User.all
      respond_to do |f|
        f.html { render :index }
        f.json { render :json => {:users => @users}}
      end
    else
      @msg = "You can't see all users, sorry about that..."
      flash.now[:alert] = @msg
      respond_to do |f|
        f.html { redirect_to 'home/logged_out' }
        f.json { render :json => {:msg => @msg }}
      end
    end
  end

  def show
    @user = User.find(params[:id])
    #binding.pry
    @books = @user.books
    @rating = @user.rating
    if current_user.mod_or_admin? || @user == current_user
      respond_to do |f|
        f.html { render :show }
        f.json { render :json => {:user => @user, :books => @books, :rating => @rating }}
      end   
    else
      @msg = "You don't have permission to look at that user's info. Come on, now you're just being creepy."
      flash.now[:alert] = @msg
      respond_to do |f|
        f.html { render 'home/logged_out' }
        f.json { render :json => {:msg => @msg }}
      end
    end
  end

  def edit
    @user = User.find(params[:id])
    if current_user.admin? || @user == current_user 
      respond_to do |f|
        f.html { render :edit }
        f.json { render :json => {:user => @user }}
      end
    else
      @msg =  "You're not allowed to edit that account. Just who do you think you are?"  
      flash.now[:alert] = @msg
      respond_to do |f|
        f.html { render 'home/logged_out' }
        f.json { render :json => {:msg => @msg }}
      end
    end
  end

  def update
    @user = User.find(params[:id])
    if @user == current_user || current_user.admin?
      if @user.update_attributes(user_params)
      @msg = 'User Info Updated! Huzzah!'
      respond_to do |f|
        f.html { redirect_to root_path, notice: @msg }
        f.json { render :json => { :user => @user, :msg => @msg}}
      end   
      else
        @msg = "Make sure all fields are filled in correctly..."
        flash.now[:alert] = @msg
        respond_to do |f|
          f.html { render :edit }
          f.json { render :json => { :msg => @msg }}
        end
      end
    else
      flash.now[:alert] = "You're not allowed to edit that account, ya weirdo." 
      respond_to do |f|
        f.html { redirect_to 'home/logged_out' }
        f.json { render :json => {:msg => @msg }}
      end  
    end
  end

  # def destroy # let devise handle this? I say yass!
  #   @user = User.find(params[:id])
  #   if (current_user.admin || current_user == @user)  
  #     @user.destroy
  #     flash[:notice] = "User Deleted!"
  #     redirect_to root_url
  #   else
  #     flash[:notice] = "User Not Deleted!"
  #     render 'home/logged_out'
  #   end
  # end

  private
 

  def user_params
    params.require(:user).permit(:real_name, :street, :city, :state, :zipcode, :role, :visible)
  end
end