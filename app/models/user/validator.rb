module User::Validator

  def error
    @error
  end

  def valid_channel?(*validations)
    clear_error!

    [*validations].each do |v|
      if v.instance_of? Hash
        send(v.keys.first.to_sym, *v.values.flatten)
      else
        send(v.to_sym)
      end
    end
    error.nil?
  end
  
  private

  def clear_error!
    @error = nil
  end

  def same_organization?(channel_id)
    chat = Chat.find_by(id: channel_id)
    if chat && chat.user.organization == self.organization
      true
    else
      @error = "User from other organization"
    end
  end
  
  def owner_chat?(chat)
    @error = "User not owner the chat" unless chat.user == self
  end

  

end
