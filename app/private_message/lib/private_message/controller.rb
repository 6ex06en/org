require "faye/websocket"

before_action :current_user?
KEEPALIVE_TIME = 15

def ws
    if Faye::WebSocket.websocket?(request.env)
      ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME })
      PrivateMessage.handle_message(ws)
      ws.rack_response
    else
      redirect_to test_path
    end
end
