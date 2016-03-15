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
    @SCROLL_CONTAINER = $('.chat__scroll-headers')
    @lengthHeaders = 0
    @maxLengthHeaders = @HEADERS_CONTAINER.width() - @computeScrollContainerWidth() - $('.chat__users-list').width() - $(".chat__header--main").width() - 10;
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
      #unless @has_header($(elem).data('id'))
      # if @headersContainerFull()
      #   $(elem).addClass("hide")
      #   @insertHeader(elem)
      # else
      #   @insertHeader(elem)
      #   if @headersContainerFull()
      #     elem.addClass("hide")
      @insertHeader(elem)
      if @headersContainerFull()
        # @borderHeader("right").css("visibility", "hidden")
        @borderHeader("right").addClass("hide")
        @insertScroller()

  insertScroller: ->
    #@scrollContainerWidth unless @computeScrollContainerWidth()
    #remainingLength = @maxLengthHeaders - @lengthHeaders
    scrollContainer = $(".chat__scroll-headers")
    if @headers[@headers.length - 1].is(".hide") || @headers[0].is(".hide")
      scrollContainer.removeClass("hide")


  insertHeader: (elem) ->
    header = @buildHeader(elem)
    if @headers[@headers.length-1] > 0
      @headers[@headers.length-1].after(header)
    else
      @HEADERS_CONTAINER.append(header)
    @addHeader(header)
    # @HEADERS_CONTAINER.append(header)

  addHeader: (elem) ->
    @headers.push elem

  buildHeader: (user_li) ->
    user_id = $(user_li).data('id')
    user_name = $(user_li).data('name')
    header = $('<div/>', {class: "chat__header", text: user_name} ).data("id", user_id)

  borderHeader: (border) ->
    return @headers[0]                   if border == "left"
    return @headers[@headers.length - 1] if border == "right"
  headersContainerFull: ->
    @lengthHeaders = 0
    $(".chat__header").each (i,e) =>
      @lengthHeaders += $(e).width() if $(e).width() > 0 #у скрытых элементов отрицательная ширина
    @lengthHeaders > @maxLengthHeaders

  computeScrollContainerWidth: ->
    scrollContainer = $(".chat__scroll-headers").removeClass("hide")
    @scrollContainerWidth = scrollContainer.width()
    scrollContainer.addClass("hide")
    @scrollContainerWidth

  debugger;

window.chatBuilder = new Chat()
//# sourceURL=index.js
//# sourceURL=index.coffee
