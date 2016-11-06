class TradesController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @user_needs_response_trades = Trade.user_needs_response(@user)
    @user_must_complete_trades = Trade.user_must_complete(@user)
    @user_completed_trades = Trade.user_completed(@user)
    @completed_by_other_trades = Trade.completed_by_other(@user)
  end
  
  def create
    @trade = Trade.new(trade_params)
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
    @trade = Trade.find(params[:id])
    if @trade.update(trade_params)
      matched_book = Book.find(@trade.matched_book_id)
      matched_book.status = "traded"
      @trade.status = 'complete'
      @trade.save
      redirect_to :index
    else
      flash[:notice] = 'Trade not updated!'
      render :root
    end
  end

  def destroy
    @trade = Trade.find(params[:id])
    initial_book = Book.find(@trade.initial_book_id)
    initial_book.status = "at_home"
    if @trade.matched_book_id
      matched_book = Book.find(@trade.matched_book_id)
      matched_book.status = "at_home"
      matched_book.save
    end
    initial_book.save
    @trade = nil
    flash[:notice] = 'Trade deleted!'
    redirect_to root_path
  end

  private
  def trade_params
    params.require(:trade).permit(:owner_id, :requester_id, :initial_book_id, :matched_book_id, :status)
  end

end


 