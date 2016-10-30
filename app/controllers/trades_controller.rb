class TradesController < ApplicationController

  def index
    @requested_trades = Trade.requested_trades
    @accepted_trades = Trade.accepted_trades
    @pending_trades = Trade.pending_trades
  end
  
  def new
  end

  def create
    binding.pry
    @trade = Trade.new(trade_params)
    if @trade.save
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
    @trade = Trade.find(params[:id])
    if @trade.update(trade_params)
      if @trade.completed?
        @trade.status = 'complete'
        @trade.save
      end
      redirect_to :index
    else
      flash[:notice] = 'Trade not updated!'
      render :root
    end
  end

  private
  def trade_params
    params.require(:trade).permit(:owner_id, :requester_id, :initial_book_id, :matched_book_id, :status)
  end

end


 