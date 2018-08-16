class ApplicationController < ActionController::Base
  # rescue_from ActiveRecord::RecordNotFound, with: :render_404
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?, :user_signed_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def render_404
    flash[:danger] = "Producto no encontrado"
    redirect_to predios_path
  end

  def user_signed_in?
    !!current_user
  end

  def authenticate_user!
    if !user_signed_in?
      flash[:danger] = 'Ocupas iniciar sesion'
      redirect_to root_path
    end
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def require_same_user
    if current_user != @user
      flash[:danger] = 'Solo puedes editar o borrar tu informacion'
      redirect_to predios_path
    end
  end

  #
  # def same_user
  #   if @info_predio  != current_user
  #     flash[:danger] = 'Solo puedes editar o borrar tu informacion'
  #     redirect_to predios_path
  #   end
  # end

  def route_not_found
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end
end
