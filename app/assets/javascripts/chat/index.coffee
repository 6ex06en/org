class PrivateMessageWS

  wss_url: ->
    protocol = if location.protocol == "https:" then "wss://" else "ws://"
    PATH = "/chat"
    uri = protocol + location.host + PATH

  setConnection: ->
    @connection = new WebSocket(@wss_url())
    @connection.onmessage = @onRecieve
    @connection.onerror = @onError
    return

  send: (options)->
    @connection.send(JSON.stringify({channel: options.channel, message: options.message}))

  onRecieve: (data)->
    console.log(data)
  onError:  ->
window.private = PrivateMessageWS
