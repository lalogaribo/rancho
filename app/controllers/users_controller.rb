class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'Usuario creado exitosamente'
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def show
    @user_predios = @user.predios
  end

  def edit
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

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user !=@user
      flash[:danger] = 'Solo puedes editar o borrar tu informacion'
      redirect_to predios_path
    end
  end
end

