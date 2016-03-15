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
    console.log(data.data)
  onError:  ->

window.private = PrivateMessageWS

class Chat
  
  constructor: ->
    @HEADERS_CONTAINER = $(".chats__headers")
    @BODY_CONTAINER = $(".chat__body")
    @USERS_LIST =  $('.chat__users-list li')
    @lengthHeaders = 0
    @maxLengthHeaders = @HEADERS_CONTAINER.width();
    @headers = []
    
    $(@USERS_LIST).on("click", (e) =>
      @createChannel(e.target)
      )
      
    $(@HEADERS_CONTAINER).on "click", ".chat__header", (e) ->
      target = $(e.target)
      user_id = target.data('id')
  
  has_header: (id) ->
    @headers.some (i) ->
      i.data('id') == id
  
  createChannel: (elem) ->
    unless @has_header($(elem).data('id'))
      if headersContainerFull()
        $(elem).addClass("hide")
        insertHeader(elem)
      else
        insertHeader(elem)
        if headersContainerFull()
          elem.addClass("hide")
  
  insertScroller: ->
    @scrollContainerWidth unless @computeScrollContainerWidth()
    remainingLength = @maxLengthHeaders - @lengthHeaders
    scrollContainer = $(".chat__scroll-headers")
    scrollContainer.removeClass("hide") if scrollContainerWidth < remainingLength
      
  insertHeader: (elem) ->
    header = @buildHeader(elem)
    @addHeader(header)
    @HEADERS_CONTAINER.append(header)
    
  addHeader: (elem) ->
    @headers.push elem
    
  buildHeader: (user_li) ->
    user_id = $(user_li).data('id')
    user_name = $(user_li).data('name')
    header = $('<div/>', {class: "chat__header", text: user_name} ).data("id", user_id)
    
  headersContainerFull: ->
    $(".chat__header").forEach (e,i) ->
      @lengthHeaders += $(e).width()
    @lengthHeaders > @maxLengthHeaders
    
  computeScrollContainerWidth: ->
    scrollContainer = $(".chat__scroll-headers").removeClass("hide")
    @scrollContainerWidth = scrollContainer.width()
    scrollContainer.addClass("hide")
    
    

window.chatBuilder = new Chat() 