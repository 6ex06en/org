module PrivateMessage
  module Validator

    CHAT_TYPE = ["ws.private:", "ws.chat:"]

    def self.included(klass)
      if klass == PrivateMessage
        klass.module_eval do
          Validator.instance_methods(false).each do |method|
            module_function method
          end
        end
      end
    end

    def validate_channel?(channel_name)
      !!(channel_name =~ /#{CHAT_TYPE[0]}/ || channel_name =~ /#{CHAT_TYPE[1]}/)
    end

    def permitted_channel?(chat_params, &block)
      block.call(chat_params)
    end

    def validate_name(chat_name)
      if validate_channel?(chat_name)
        chat_type = chat_name[/(#{CHAT_TYPE[0]}|#{CHAT_TYPE[1]})/]
        [chat_type, chat_name.sub(chat_type, '')]
      end
    end
    
    def correct_data?(json)
      json.keys.sort == [:channel, :message] 
    end

  end
end

# class Hz
#   include PrivateMessage::Validator
# end

# x = hz.to_proc(:validate_channel?, "ws.chat:")
# p x.call
