window.App ||= {}
class App.TradingFloor extends App.Base

  # Rails server code can pass in some bootstrap data if necessary, which we will save off for use anywhere on the client
  constructor: (bootstrap_data={}) ->
    super

    $(document).on 'page:before-change', (e) ->
      if typeof $App.tradeStream != 'undefined'
        $App.tradeStream.close()
        $App.tradeStream = undefined

    this

  show: () ->
    $App.tradeStream = new EventSource('/trade-stream/exchange/' + $App.currentExchange.id)
    $App.tradeStream.addEventListener 'exchange_' + $App.currentExchange.id + '_trades.create', (e) ->
      trade = $.parseJSON(e.data)

      $("[data-exchange=\"#{trade.exchange_id}\"][data-market=\"#{trade.market_id}\"]").each ->
        $this = $(this)
        $price = $('.price', $this)
        new_price = Math.round(parseFloat(trade.price) * 100000000) / 100000000

        if new_price > $price.text()
          color = '#dff0d8'
        else
          color = '#f2dede'

        $price.text(new_price)
        $this.effect("highlight", { color: color }, 3000);