class TradesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
    @requested_trades = Trade.requested_trades(@user)
    @accepted_trades = Trade.accepted_trades(@user)
    @my_completed_requested_trades = Trade.my_completed_requested_trades(@user)
    @my_completed_accepted_trades = Trade.my_completed_accepted_trades(@user)
  end
  
  def new
    binding.pry
  end

  def create
    binding.pry
    @trade = Trade.new(trade_params)
    if @trade.save
        @initial_book = Book.find(@trade.initial_book_id)
        @initial_book.status = "in_trade"
        @initial_book.save
        flash[:notice] = "You've initiated a new trade. Please wait for a response soon."
      redirect_to :index
    else
      flash[:notice] = 'There was a problem creating a trade!'
      render :root
    end
  end

  # def edit
  #   @trade = Trade.find(params[:id])
  # end

  def update
    binding.pry
    @trade = Trade.find(params[:id])
    if @trade.update(trade_params)
        @matched_book = Book.find(@trade.matched_book_id)
        @matched_book.status = "in_trade"
        @trade.status = 'complete'
        @trade.save
      end
      redirect_to :index
    else
      flash[:notice] = 'Trade not updated!'
      render :root
    end
  end

  def destroy
    @trade = Trade.find(params[:id])
        initial_book = Book.find(@trade.initial_book_id)
        initial_book.status = "in_trade"
        matched_book = Book.find(@trade.matched_book_id)
        matched_book.status = "in_trade"
        initial_book.save
        matched_book.save
        @trade = nil
        flash[:notice] = 'Trade deleted!'
        redirect_to '/home/index'
      end
    end

  private
  def trade_params
    params.require(:trade).permit(:owner_id, :requester_id, :initial_book_id, :matched_book_id, :status)
  end

end


 