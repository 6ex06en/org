class User

  # before_create :format_name

  include PrivateMessage::Validator

  def allowed_channel?(*channel) #TODO: протестировать
    types = PrivateMessage::Validator::CHAT_TYPE
    chat_type, chat_name = channel
    case chat_type
      when types[0]
        id_s = [self.id, User.find_by(name: chat_name).id].compact
        # id_s = chat_name.split("_").sort
        # if (User.ids & id_s) == id_s
        if id_s.length == 2
          users = User.includes(:organization).where(id: id_s[0], id: id_s[1])
          users.first.organization_id == users.second.organization_id
        end
      when types[1]
        !!Chat.format_name(type: types[1], name: chat_name)
        # valid_chat_name = Chat.format_name(type: types[1], name: chat_name)
        #Chat.find_by(name: valid_chat_name).nil? || Chat.find_by(name: valid_chat_name).members.ids.include?(current_user.id)
    end
  end

end

class Chat

  include PrivateMessage::Validator

  def self.format_name(options) # TODO: протестировать
    chat_type = PrivateMessage::Validator::CHAT_TYPE
    case options[:type]
      when chat_type[0]
        first_id, second_id = options[:name].split("_")
        # first_id = User.find_by(id: options[:user1].id).id
        # second_id = User.find_by(id: options[:user2].id).id
        if first_id && second_id
          first_id > second_id ? "#{second_id}_#{first_id}" : "#{first_id}_#{second_id}"
        end
      when chat_type[1]
        chat = Chat.find_by(:name => options[:name])
        "#{chat.name}_#{chat.members.first.name}"
    end
  end

  # def self.modify_name(chat_name)
  #   newname = chat_name + rand(10000).to_s
  #   while Chat.find_by(name: newname)
  #     newname = chat_name + rand(10000).to_s
  #   end
  #   newname
  # end

  # def self.validate_name(chat_name)
  #   chat_type = chat_name[/(#{CHAT_TYPE[0]}|#{CHAT_TYPE[1]})/]
  #   if chat_type
  #     chat = chat_name.sub(chat_type, '')
  #     case chat_type
  #       when CHAT_TYPE[0] then chat
  #       when CHAT_TYPE[1] then chat
  #     end
  #   end
  # end

end

# p Chat.validate_name("ws.private:1_super_chat")
