module User::Validator

  def error
    @error = nil
  end

  def valid? validations
    clear_error!

    validations.each do |v|
      v.instance_of? Hash ? send(v.keys.first.to_sym, *[v.values]) : send(v)
    end
    error.nil?
  end

  private

  def clear_error!
    @error = nil
  end

  def same_organization?(channel_id)
    chat = Chat.find_by(id: channel_id)
    if chat && chat.owner.organization == self.organization
      true
    else
      @error = "User from other organization"
    end
  end

end
