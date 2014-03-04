window.App ||= {}
class App.TradingFloor extends App.Base

  # Rails server code can pass in some bootstrap data if necessary, which we will save off for use anywhere on the client
  constructor: (bootstrap_data={}) ->
    super
    this

  show: () ->
    $App.tradeStream = new EventSource('/trade-stream/exchange/' + $App.currentExchange.id)
    $App.tradeStream.addEventListener 'exchange_' + $App.currentExchange.id + '_trades.create', (e) ->
      trade = $.parseJSON(e.data)
      console.log trade

      $("[data-exchange=\"#{trade.exchange_id}\"][data-market=\"#{trade.market_id}\"]").each ->
        $this = $(this)
        $price = $('.price', $this)
        old_price = $price.text()
        new_price = Math.round(parseFloat(trade.price) * 1000000) / 1000000

        if new_price != old_price
          $this.clearQueue().stop()
          $price.text(trade.price)

          if new_price > old_price
            color = '#dff0d8'
          else
            color = '#f2dede'

          $this.delay(3000).show(->
            $price.text(new_price)
          ).effect("highlight", { color: color }, 3000);

    $(document).off('page:before-change').on 'page:before-change', (e) ->
      if $App.tradeStream
        $App.tradeStream.close()
        $App.tradeStream = undefined
