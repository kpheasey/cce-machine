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