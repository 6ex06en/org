class OptionsController < ApplicationController
  before_action :signed_in_user

  def update
    if @current_user.option
      option = @current_user.option
    else
      option = @current_user.create_option
    end
    if option.update_attributes(option_params)
      respond_to do |format|
        format.html { redirect_to root_path}
      end
    end
  end

  private

  def option_params
    params.require(:option).permit(:avatar, :avatar_cache)
  end

end
