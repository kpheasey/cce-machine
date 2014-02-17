class ChartsController < ApplicationController
  before_filter :check_params, :parse_params
  respond_to :json

  def line
    @line = Chart::Line.new(
        @market,
        @exchanges,
        params[:start_date],
        params[:end_date],
        params[:points].to_i
    )

    render json: @line.data
  end

  def candlestick
    @candlestick = Chart::Candlestick.new(
        @market,
        @exchanges,
        params[:start_date],
        params[:end_date],
        params[:points].to_i
    )

    render json: @candlestick.data
  end

  private

  def check_params
    raise 'params[:exchanges] not defined' if params[:exchanges].nil?
    raise 'params[:market] not defined' if params[:market].blank?
  end

  def parse_params
    @exchanges = Exchange.where(id: params[:exchanges].split(','))
    @market = Market.find(params[:market])
  end
end
