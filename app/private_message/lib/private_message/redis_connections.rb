require_relative "errors"

module PrivateMessage
	class RedisConnections
			
		class << self
			
			def all
				@connections ||= []
			end
			
			def add(subscriber)
				raise BaseError.new("Was added not Redis::Subscriber instance") unless subscriber.instance_of? PrivateMessage::Subscriber 
				@connections.push subscriber
			end
			
			def find_by_channel(channel)
				all.find {|subscriber| subscriber.channel == channel }
			end
			
		end
			
	end
	
end