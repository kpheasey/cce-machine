window.App ||= {}
class App.TradingFloor extends App.Base

  # Rails server code can pass in some bootstrap data if necessary, which we will save off for use anywhere on the client
  constructor: (bootstrap_data={}) ->
    super
    this

  show: () ->
    source = new EventSource('/trade-stream/exchange/' + $App.currentExchange.id)
    source.addEventListener 'trades.create', (e) ->
      trade = $.parseJSON(e.data)
      console.log trade
