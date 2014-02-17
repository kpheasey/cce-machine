class Chart

  attr_accessor :exchanges, :market, :start_date, :end_date, :points
  attr_reader :interval

  def initialize(exchanges, market, start_date = nil, end_date = nil, points = nil)
    @exchanges = (exchanges.is_a?(Array) || exchanges.is_a?(ActiveRecord::Relation)) ? exchanges : [exchanges]
    @market = market
    @end_date = end_date.nil? ? Time.now : Time.parse(end_date)
    @start_date = start_date.nil? ? @end_date - 6.hours : Time.parse(start_date)
    @points = points || 12
    @interval = (@end_date.to_i - @start_date.to_i) / @points
  end

end
