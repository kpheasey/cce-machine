window.App ||= {}
class App.TradingFloor extends App.Base

  constructor: (bootstrap_data={}) ->
    super
    return this

  show: () ->
    $this.startTradeSteam()
    $this.initializeChart()

    return

  initializeChart: ->
    # TODO: add volume to candlestick chart
    # http://www.highcharts.com/stock/demo/candlestick-and-volume
    # See source code from the JSONP handler at https://github.com/highslide-software/highcharts.com/blob/master/samples/data/from-sql.php

    end_time = Math.round(+new Date())
    start_time = end_time - (1000 * 60 * 60 * 24)
    url = """
          /charts/candlestick.json?
          exchange=#{$this.currentExchange.id}&
          market=#{$this.currentMarket.id}&
          start_time=#{start_time}&
          end_time=#{end_time}
          """
    $.getJSON url, (data) ->

      # Add a null value for the end date

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
              type: "month"
              count: 1
              text: "1m"
            }
            {
              type: "all"
              text: "All"
            }
          ]
          inputEnabled: false # it supports only days
          selected: 0 # hour

        xAxis:
          events:
            afterSetExtremes: $this.afterSetExtremes

          minRange: 1800 * 1000 # one hour

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
    url = """
          /charts/candlestick.json?
          exchange=#{$this.currentExchange.id}&
          market=#{$this.currentMarket.id}&
          start_time=#{Math.round(e.min)}&
          end_time=#{Math.round(e.max)}
          """
    $.getJSON url, (data) ->
      console.log data
      chart.series[0].setData data
      chart.hideLoading()
      return

    return