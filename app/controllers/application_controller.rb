class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:danger] = 'Ocupas iniciar sesion'
      redirect_to root_path
    end
  end

  def require_same_user
    if current_user != @user
      flash[:danger] = 'Solo puedes editar o borrar tu informacion'
      redirect_to predios_path
    end
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def route_not_found
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end
  #
  # def authenticate_admin_user!
  #   if logged_in? && current_admin_user
  #     true
  #   end
  # end
  #
  # def current_admin_user
  #   @current_user
  # end
end
