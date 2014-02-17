class MarketsController < ApplicationController

  def index

  end

  def show
    @market = Market.friendly.find(params[:id])
  end

end
