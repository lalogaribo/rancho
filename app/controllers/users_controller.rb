class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  layout 'dashboard'
  before_action :require_same_user, only: %i[edit update destroy show]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.create_new_token_chart
      UserMailer.registration_confirmation(@user).deliver_now
      flash[:success] = 'Por favor confirma tu correo electronico, para continuar con el proceso'
      # #session[:user_id] = @user.id
      # #flash[:success] = "Bienvenido #{@user.name}"
      # #redirect_to user_path(@user)
      redirect_to root_url
    else
      flash[:error] = 'Tu peticion no pudo ser procesada, intenta nuevamente.'
      render :new
    end
  end

  def show
    @user_predios = @user.predios
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'Usuario actualizado exitosamente'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    if @user.destroy
      flash[:danger] = "#{@user.name} ha sido eliminado correctamente"
      redirect_to users_path
    end
  end

  def confirm_email
    user = User.find_by_confirm_token(params[:token])
    if user
      user.validate_email
      user.save(validate: false)
      flash[:success] = 'Tu usuario ha sido confirmado. Por favor autenticate para continuar.'
      redirect_to login_url
    else
      flash[:error] = 'Lo sentimos, este usuario ya fue confirmado previamente.'
      redirect_to root_url
    end
  end

  def reset_chart_token
    user = User.find_by_id(params[:id])
    if user
      user.create_new_token_chart
      UserMailer.reset_chart_token(user).deliver_now
      flash[:success] = 'Se ha enviado un correo electronico con tu nuevo token.'
      redirect_to charts_url
    else
      flash[:error] = 'Lo sentimos, este usuario no existe en nuestros records.'
      redirect_to charts_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
