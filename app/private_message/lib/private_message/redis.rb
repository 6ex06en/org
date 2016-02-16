require 'redis'
require_relative "adapter"

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

    def initialize(connection = {})
      @redis_sub = Redis.new(connection_params(connection))
    end


    def subscribe(channel)
      Thread.new do
        begin
          redis_sub.subscribe(channel) do |on|
            on.message do |chan, mes|
              puts "#{chan}: #{mes}"
              redis_sub.unsubscribe(chan) if mes == "unsubscribe"
            end
            on.unsubscribe do |chan|
              puts "unsubscribe from #{chan}"
            end
          end
        rescue Redis::BaseConnectionError => error
          puts "#{error}, retrying in 1s"
          sleep 1
          retry
        end
      end
    end

  end

end
