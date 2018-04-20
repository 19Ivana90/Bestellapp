class ConfirmationsController < Devise::ConfirmationsController
  before_action :set_user_from_confirmation_token, only: [:show, :update]

  def show
    render @user.valid? ? :show : :new
  end

  def update
    # @user.valid? checks if there is a user for the given confirmation token
    if @user.valid?
      if @user.update_and_confirm(user_attributes)
        sign_in(:user, @user) # sign right in
        set_flash_message(:notice, :confirmed_and_signed_in)
        redirect_to after_confirmation_path_for(resource_name, @user)
      else
        render :show
      end
    else
      redirect_to user_confirmation_url(confirmation_token: params[:confirmation_token])
    end
  end

private

  def user_attributes
    params[:user] ||= {}
    params[:user].permit(:first_name, :last_name, :password)
  end

  def set_user_from_confirmation_token
    @user = User.find_or_initialize_with_error_by(:confirmation_token, params[:confirmation_token])
  end

end
