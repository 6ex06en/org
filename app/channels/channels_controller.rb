#require 'faye/websocket'
require File.expand_path("../../private_message/lib/private_message", __FILE__)

class ChannelsController < ApplicationController

    KEEPALIVE_TIME = 15

    def chat
        puts "req +++ "
        puts Faye::WebSocket.websocket?(request.env)
        redirect_to root_path and return unless Faye::WebSocket.websocket?(request.env)
        ws = Faye::WebSocket.new(request.env, nil, {ping: KEEPALIVE_TIME})
        p "current_user - #{current_user}"
        PrivateMessage.handle_message(ws, current_user) if current_user
        render :nothing => true
        # render :nothing => true if Faye::WebSocket.websocket?(request.env)
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
