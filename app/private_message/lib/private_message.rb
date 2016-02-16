require_relative "private_message/redis.rb"
require_relative "private_message/validator.rb"
# проверка на ВС пройдена, пользователь current_user
module PrivateMessage

    include Validator


    def self.handle_message(ws)

      ws.on :open do |event|
        p [:open, ws.object_id] # сделать присоединение к каналу сразу, а не после отправки сообщения
        Clients.add(ws)
      end

      ws.on :message do |event|
        chat_type, chat_name = validate_name(event.data[:channel])
        message = event.data[:message]
        client = Clients.connected.find{|c| c.user == current_user}
        if client && client.channels.include?(chat_name)
          Publisher.up.publish(chat_name, message)
        elsif client && User.allowed_channel?(chat_name)
          Subscriber.subscribe(chat_name)
          client.channels.push chat_name # отправит сам себе
          Publisher.up.publish(chat_name, message)
        end
        # p [:message, event.data]
        # # clients.each {|client| client.send(event.data) }
        # puts @clients
        # @redis.publish(CHANNEL, event.data)
      end
      #
      ws.on :close do |event|
          Publisher.up.publish(event.data[:channel], "unsubscribe") if event.data[:channel]
          client = Clients.connected.find{|c| c.user == current_user}
          client.connection = nil
          client.remove(client)  if client.channels.empty?
          # p [:close, ws.object_id, event.code, event.reason]
          # @clients.delete(ws)
          # ws = nil
      end
    end
    # def self.get_connection
    #   if validate_request
    #     subscribe_to(:channel)
    #   end
    #
    # end
    #
    # def set.subscribe_to
    #   client = Client.new(ws)
    #   Subscriber.new(client)
    #
    # end

    #p class_methods

end

# p PrivateMessage::CHAT_TYPE

# - приходить соединение
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
