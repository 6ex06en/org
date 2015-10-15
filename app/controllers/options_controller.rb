class OptionsController < ApplicationController
  before_action :signed_in_user

  def create
    # option = @current_user.create_option unless @current_user.option
    option = @current_user.build_option(option_params)
    if option.save
      respond_to do |format|
        format.html { redirect_to edit_user_path(@current_user)}
      end
    end
  end

  private

  def option_params
    params.require(:option).permit(:avatar, :avatar_cache)
  end

end
