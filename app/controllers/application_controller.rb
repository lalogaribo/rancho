class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:danger] = 'Ocupas iniciar sesion, para hacer dicha accion'
      redirect_to root_path
    end
  end

  def require_same_user
    if current_user !=@user
      flash[:danger] = 'Solo puedes editar o borrar tu informacion'
      redirect_to predios_path
    end
  end
end
