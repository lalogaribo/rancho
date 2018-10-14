class SessionsController < ApplicationController
  def new
  end

  def new_user
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.email_confirmed
        session[:user_id] = user.id
        flash[:success] = "Bienvenido #{user.name}, haz iniciado sesion exitosamente! "
        redirect_to user
      else
        flash[:error] = 'Por favor activa tu cuenta, siguiendo las instrucciones en el correo de confirmacion que haz recibido.'
        redirect_to login_url
      end
    else
      flash.now[:error] = 'Hubo problemas con tus credenciales'
      render 'new'
    end
  end

  def destroy
    log_out
    flash[:success] = 'Haz cerrado sesion'
    redirect_to root_path
  end
end