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

  def allowed_channel?(channel)
  end

end
