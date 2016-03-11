require_relative "private_message/redis.rb"
require_relative "private_message/redis_connections.rb"
require_relative "private_message/validator.rb"
require_relative "private_message/clients.rb"
require_relative "../../helpers/sessions_helper.rb"
require "timeout"
# проверка на ВС пройдена, пользователь current_user
module PrivateMessage

    include Validator
    # extend SessionsHelper

    def self.handle_message(ws, valid_user)

      ws.on :open do |event|
        p [:open, ws.object_id]
        Clients.add(ws, valid_user)
      end

      ws.on :message do |event|
        begin
          recieved_data = parse_data(event.data)
          p recieved_data
          if correct_data?(recieved_data) && validate_channel?(recieved_data["channel"])
            send_message(recieved_data, valid_user)
          end
        rescue => e
          p e
        end
        # p [:message, event.data]
        # # clients.each {|client| client.send(event.data) }
        # puts @clients
        # @redis.publish(CHANNEL, event.data)
      end
      #
      ws.on :close do |event|
          p [:close, event.code, event.reason]
          recieved_data = parse_data(event.data)
          Publisher.up.publish(recieved_data["channel"], "unsubscribe")
          clear_redis(valid_user, recieved_data["channel"])
          # p [:close, ws.object_id, event.code, event.reason]
          # @clients.delete(ws)
          # ws = nil
      end
      ws.rack_response
    end
    
    def self.parse_data(data)
      begin
        JSON.parse(data)
      rescue
        puts "WebSocket: Data is a not json"
      end
    end
    
    def self.send_message(data, user)
      p [:message, data]
      p "clients_count = #{Clients.connected.count}"
      p "current_user - #{user}"
      chat_name, message = data.values_at("channel", "message")
      client = Clients.connected.find{|client| client.user == user}
      if client && RedisConnections.find_by_channel(chat_name) 
        Publisher.up.publish(chat_name, message)
      elsif client && client.has_channel?(chat_name)
        sub = Subscriber.new
        sub.new_listener(chat_name)
        wait_redis_up
        p "start publishing"
        Publisher.up.publish(chat_name, message)
        p "end publishing"
      end
    end
    
    def self.wait_redis_up
      Timeout.timeout(2) do
        loop do 
          p "#{Subscriber.sub_threads.count}  - from loop"
          break if Subscriber.sub_threads.empty?
        end
      end
    end
    
    def self.clear_redis(user, channel)
      Clients.connected.delete_if {|c| c.user == user}
      with_channel = RedisConnections.all.select {|r| r.channel == channel}
      RedisConnections.all.delete(with_channel.first) if with_channel.one?
    end
    
end


#TODO:

# - приходит соединение
#   - проверить ws ли
#     - если ws
#       - при попытке установить соединение:
#         1. проверить авторизованный ли пользователь
#           - если авторизован
#             1. пропустить
#           - если нет
#             - закрыть канал
#             - объяснить причину разрыва
#         2. проверить доступен ли ему запрашиваемый канал
#           - если доступен
#             1. сохранить соединение
#             2. создать подписчика
#             3. подписать на канал
#           - если нет
#             - закрыть канал
#             - объяснить причину закрытия
#       - при отправке сообщения
#         1. отправить всем сообщение, кто находится в данном канале
#         2. сохранить сообщение в базе
#       - при разрыве соединения
#         - разорвать соединение
#         - убрать из подписчиков
#     - если не ws
#       1. редиректнуть
