require_relative "errors"

module PrivateMessage
  class RedisConnections
      
      # @connections = []
      
      def self.all
         @connections ||= []
      end
      
      def self.add(subscriber)
        raise BaseError.new("Was added not Redis::Subscriber instance") unless subscriber.instance_of? PrivateMessage::Subscriber 
         @connections.push subscriber
      end
      
  end
  
end