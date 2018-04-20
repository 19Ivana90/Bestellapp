class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  prepend_before_action :authenticate_user!

  private

  def require_admin
    unless current_user.admin?
      redirect_to root_url, alert: 'Diese Aktion kann nur von einem Administrator ausgeführt werden.'
      return false
    end
  end

end
