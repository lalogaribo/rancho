class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_token
      @user.send_password_reset_email
      flash[:info] = "Un Email fue enviado a tu correo electronico con las instrucciones para resetear tu contrasena"
      redirect_to root_url
    else
      flash.now[:danger] = "El correo no fue encontrado"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      flash[:danger] = "Las contrasenas son requeridas"
      render 'edit'
    elsif @user.update_attributes(user_params)
      @user.clean_reset_token
      @user.save(validate: false)
      session[:user_id] = @user.id
      flash[:success] = "Bienvenido #{@user.name} Su contrasena ha sido cambiada."
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # Confirms a valid user.
  def valid_user
    unless (@user && @user.email_confirmed? &&
        @user.authenticated_reset_token?(params[:id]))
      flash[:info] = "Opps ha ocurrido algun problema, realiza el proceso nuevamente"
      redirect_to root_url
    end
  end

  # Checks expiration of reset token.
  def check_expiration
    if @user.password_reset_expired?
      flash[:info] = "El cambio de contrasena ha expirado."
      redirect_to new_password_reset_url
    end
  end
end
