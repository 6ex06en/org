#require 'faye/websocket'
require File.expand_path("../../private_message/lib/private_message", __FILE__)

class Chat < ApplicationController
    
    KEEPALIVE_TIME = 15
    #puts self.methods
    
    def chat
        puts "req +++ "
        #p request
        # p request.env
        puts Faye::WebSocket.websocket?(request.env)
        # puts Faye::WebSocket.websocket?(request)
        redirect_to root_path and return unless Faye::WebSocket.websocket?(request.env)
        ws = Faye::WebSocket.new(request.env, nil, {ping: KEEPALIVE_TIME})
        # p ws
        PrivateMessage.handle_message(ws)
        render :nothing => true if Faye::WebSocket.websocket?(request.env)
        #redirect_to test_chat_path
    end

    def call(env)
        #puts self
        #puts "++=+"
        #env["action_dispatch.request.path_parameters"] = {action: "test", controller: "chats"}
        #path_parameters= {action: "test", controller: "chats"}
        #self.response_body = "Hello World!"
        #puts "***"
        #puts methods
        # puts env['action_dispatch.request.path_parameters']
        # ["200", {}, ["all right"]]
        # redirect_to "chats/test" and return
    end
end