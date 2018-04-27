class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = 'Haz iniciado sesion exitosamente!'
      redirect_to user
    else
      flash.now[:danger] = 'Hubo problemas con tus credenciales'
      render 'new'
    end
  end

  def destroy
    log_out
    flash[:success] = 'Haz cerrado sesion'
    redirect_to root_path
  end
end