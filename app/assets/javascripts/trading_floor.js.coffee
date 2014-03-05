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
    # TODO: add volume to candlestick chart
    # http://www.highcharts.com/stock/demo/candlestick-and-volume
    # See source code from the JSONP handler at https://github.com/highslide-software/highcharts.com/blob/master/samples/data/from-sql.php
    $.getJSON "http://www.highcharts.com/samples/data/from-sql.php?callback=?", (data) ->

      # Add a null value for the end date
      data = [].concat(data, [[
                                Date.UTC(2011, 9, 14, 19, 59)
                                null
                                null
                                null
                                null
                              ]])

      # create the chart
      $("#chart").highcharts "StockChart",
        chart:
          type: "candlestick"
          zoomType: "x"

        navigator:
          adaptToUpdatedData: false
          series:
            data: data

        scrollbar:
          liveRedraw: false

        title:
          text: "AAPL history by the minute from 1998 to 2011"

        subtitle:
          text: "Displaying 1.7 million data points in Highcharts Stock by async server loading"

        rangeSelector:
          buttons: [
            {
              type: "hour"
              count: 1
              text: "1h"
            }
            {
              type: "day"
              count: 1
              text: "1d"
            }
            {
              type: "week"
              count: 1
              text: "1w"
            }
            {
              type: "mont"
              count: 1
              text: "1m"
            }
            {
              type: "all"
              text: "All"
            }
          ]
          inputEnabled: false # it supports only days
          selected: 4 # all

        xAxis:
          events:
            afterSetExtremes: $this.afterSetExtremes

          minRange: 3600 * 1000 # one hour

        series: [
          data: data
          dataGrouping:
            enabled: false
        ]

      return

  ###
  Load new data depending on the selected min and max
  ###
  afterSetExtremes: (e) ->
    currentExtremes = @getExtremes()
    range = e.max - e.min
    chart = $("#chart").highcharts()
    chart.showLoading "Loading data from server..."
    $.getJSON "http://www.highcharts.com/samples/data/from-sql.php?start=" + Math.round(e.min) + "&end=" + Math.round(e.max) + "&callback=?", (data) ->
      chart.series[0].setData data
      chart.hideLoading()
      return

    return