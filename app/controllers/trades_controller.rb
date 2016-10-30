class TradesController < ApplicationController

  def index
    @trades = current_user.trades
  end
  
  def new
  end

  def create
    @trade = Trade.new(trade_params)
    if @trade.save
      redirect_to :index
    else
      notice: 'There was a problem creating a trade!'
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
      notice: 'Trade not updated!'
      render :root
    end
  end

  private
  def trade_params
    params.require(:trade).permit(:owner_id, :requester_id, :initial_book_id, :matched_book_id, :status)
  end

end


