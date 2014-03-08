class ChartsController < ApplicationController
  before_filter :check_params, :parse_params
  respond_to :json

  def line
    @line = Chart::Line.new(
        @market,
        @exchanges,
        params[:start_time],
        params[:end_time],
        params[:points].to_i
    )

    render json: @line.data
  end

  def candlestick
    @candlestick = Chart::Candlestick.new(
        @exchange,
        @market,
        params[:start_time],
        params[:end_time]
    )

    render json: @candlestick.data
  end

  private

  def check_params
    raise 'params[:exchanges] or params[:exchange] not defined' if (params[:exchanges].blank? && params[:exchange.blank?])
    raise 'params[:market] not defined' if params[:market].blank?
  end

  def parse_params
    @exchanges = Exchange.where(id: params[:exchanges].split(',')) unless params[:exchanges].blank?
    @exchange = Exchange.find(params[:exchange]) unless params[:exchange].blank?
    @market = Market.find(params[:market])
  end
end
