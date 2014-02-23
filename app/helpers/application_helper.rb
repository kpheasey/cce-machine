module ApplicationHelper

  # Returns the full title on a per-page basis
  #
  # @param [String] page_title  Title of the page
  # @return [String]
  def full_title(page_title = '')
    base_title = 'CCE Machine'

    if page_title.empty?
      base_title
    else
      "#{base_title} - #{page_title}"
    end
  end

  def markets
    @markets ||= Market.active
  end

  def exchanges
    @exchanges ||= Exchange.active
  end

  def chart_types
    @chart_types ||= {
      candlestick: 'Candlestick',
      line: 'Line (average)'
    }
  end

  def current_exchange
    @current_exchange ||= Exchange.default
  end

  def current_market
    @current_market ||= Market.default
  end

end
