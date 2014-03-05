window.App ||= {}
class App.Base

  # Rails server code can pass in some bootstrap data if necessary, which we will save off for use anywhere on the client
  constructor: (bootstrap_data={}) ->
    @bd = bootstrap_data
    return this

  startTradeSteam: () ->
    $(document).on 'page:before-change', (e) ->
      if typeof $this.tradeStream != 'undefined'
        $this.tradeStream.close()
        $this.tradeStream = undefined

    $this.tradeStream = new EventSource('/trade-stream/exchange/' + $this.currentExchange.id)
    $this.tradeStream.addEventListener 'exchange_' + $this.currentExchange.id + '_trades.create', @update_market_value

    return

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

    return