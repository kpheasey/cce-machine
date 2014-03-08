class Chart

  def initialize(markets, exchanges = [], start_date = nil, end_date = nil, points = nil)
    @exchanges = (exchanges.is_a?(Array) || exchanges.is_a?(ActiveRecord::Relation)) ? exchanges : [exchanges]
    @markets = (markets.is_a?(Array) ||  markets.is_a?(ActiveRecord::Relation)) ? markets : [markets]
    @end_time = end_date.nil? ? Time.now : Time.parse(end_date)
    @start_time = start_date.nil? ? @end_time - 6.hours : Time.parse(start_date)
  end

end
