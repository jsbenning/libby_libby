class TradesController < ApplicationController

  def index
    @trades_requested = Trade.trades_requested(current_user)
    @trades_received = Trade.trades_received(current_user)
  end
  
  def new
  end

  def create
    @trade = Trade.new(trade_params)
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
      redirect_to "/trades"
    else
      render 'edit'
    end
  end

  private
  def trade_params
    params.require(:trade).permit(:owner_id, :requester_id, :initial_book_id, :matched_book_id, :status)
  end

end


