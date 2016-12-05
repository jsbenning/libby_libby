class TradesController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @trades_user_received = Trade.user_received(@user)
    @trades_user_requested = Trade.user_requested(@user)
    @trades_user_completed = Trade.user_completed(@user)
    @trades_completed_by_other= Trade.completed_by_other(@user)
  end
  
  def create
    @trade = Trade.create(trade_params)
    if @trade.save
        initial_book = Book.find(@trade.initial_book_id)
        initial_book.status = "traded"
        initial_book.save
        flash[:notice] = "You've just initiated a new trade! Please wait for a response soon."
      redirect_to action: "index"
    else
      flash[:notice] = 'There was a problem creating a trade!'
      render :root
    end
  end


  def update
    binding.pry
    @trade = Trade.find(params[:id])
    if @trade.update(trade_params)
      matched_book = Book.find(@trade.matched_book_id)
      matched_book.status = "traded"
      @trade.status = 'complete'
      @trade.save
      redirect_to action: "index"
    else
      flash[:notice] = 'Trade not updated!'
      render :root
    end
  end

  def destroy
    @trade = Trade.find(params[:id])
    if @trade.owner_id == current_user.id || @trade.requester_id == current_user.id
      initial_book = Book.find(@trade.initial_book_id)
      initial_book.status = "at_home"
      if @trade.matched_book_id
        matched_book = Book.find(@trade.matched_book_id)
        matched_book.status = "at_home"
        matched_book.save
      end
      initial_book.save
      @trade.destroy
      flash[:notice] = 'Trade deleted!'
      redirect_to root_path
    else
      flash[:notice] = "You don't have permission to delete this trade"
      render :root
    end
  end

  private

  def trade_params
    params.require(:trade).permit(:owner_id, :requester_id, :initial_book_id, :matched_book_id, :status, :initial_book_owner_rating, :matched_book_owner_rating)
  end

end


 