require 'redis'
require_relative "adapter"
require_relative "redis_connections"

module PrivateMessage

  class Publisher

    extend Adapter

    def self.up(connection = {})
      @redis_pub ||= Redis.new(connection_params(connection))
    end

    def self.publish(channel ,message)
      begin
        @redis_pub.publish(channel, message)
      rescue
        raise "RedisPublisher not work!"
      end
    end

  end

  class Subscriber

    include Adapter

    attr_reader :redis_sub
    attr_accessor :channel
    
    def self.sub_threads
      @waiting ||= [] 
    end

    def initialize(connection = {})
      @redis_sub = Redis.new(connection_params(connection))
    end


    def subscribe(channel)
      Thread.new do
        Subscriber.sub_threads.push(Thread.current)
        begin
          redis_sub.subscribe(channel) do |on|
            on.message do |chan, mes|
              Clients.connected.each do |client|
                client.connection.send(mes) if client.has_channel? chan
              end
              redis_sub.unsubscribe(chan) if mes == "unsubscribe"
            end
            on.unsubscribe do |chan|
              puts "unsubscribe from #{chan}"
            end
            p "#{Subscriber.sub_threads} - sub_threads from thread"
            p "subscribe running"
          end
        rescue Redis::BaseConnectionError => error
          raise error
        end
        Subscriber.sub_threads.delete(Thread.current)
      end
      p self
      self.channel = channel
      RedisConnections.add self
    end
    
    def has_connection?(channel)
      RedisConnections.all.find {|r| r.channel == channel }
    end
    
    def new_listener(channel)
      connection = has_connection?(channel)
      subscribe(channel) unless connection
    end

  end

end
