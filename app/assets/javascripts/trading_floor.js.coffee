window.App ||= {}
class App.TradingFloor extends App.Base

  # Rails server code can pass in some bootstrap data if necessary, which we will save off for use anywhere on the client
  constructor: (bootstrap_data={}) ->
    super

    $(document).on 'page:before-change', (e) ->
      if typeof $this.tradeStream != 'undefined'
        $this.tradeStream.close()
        $this.tradeStream = undefined

    this

  show: () ->
    $this.tradeStream = new EventSource('/trade-stream/exchange/' + $this.currentExchange.id)
    $this.tradeStream.addEventListener 'exchange_' + $this.currentExchange.id + '_trades.create', $this.update_market_value
    $this.initializeChart()


  update_market_value: (event) ->
    trade = $.parseJSON(event.data)

    $("[data-exchange=\"#{trade.exchange_id}\"][data-market=\"#{trade.market_id}\"]").each ->
      $this = $(this)
      $price = $('.price', $this)
      new_price = Math.round(parseFloat(trade.price) * 100000000) / 100000000

      if new_price > $price.text()
        color = '#dff0d8'
      else
        color = '#f2dede'

      $price.text(new_price)
      $this.effect("highlight", { color: color }, 3000)

  initializeChart: ->
    # TODO: implement asynchronous candle stick chart loading.
    # http://jsfiddle.net/gh/get/jquery/1.9.1/highslide-software/highcharts.com/tree/master/samples/stock/demo/lazy-loading/
    $.getJSON "http://www.highcharts.com/samples/data/jsonp.php?filename=aapl-ohlc.json&callback=?", (data) ->

      # create the chart
      $("#chart").highcharts "StockChart",
        rangeSelector:
          selected: 1

        title:
          text: "AAPL Stock Price"

        series: [
          type: "candlestick"
          name: "AAPL Stock Price"
          data: data
          dataGrouping:
            units: [
              [
                "week" # unit name
                [1] # allowed multiples
              ]
              [
                "month"
                [1, 2, 3, 4, 6]
              ]
            ]
        ]

      return

