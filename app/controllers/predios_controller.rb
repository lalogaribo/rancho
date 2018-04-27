class PrediosController < ApplicationController
  before_action :require_user, except: [:show]
  layout 'dashboard'
  def index
    @predios = current_user.predios
  end

  def new
    @predio = Predio.new
  end
  def show
    @predio = Predio.find(params[:id])
  end

  def create
    @predio = Predio.new(predio_params)
    @predio.user = current_user
    if @predio.save
      flash[:success] = 'Predio creado exitosamente'
      redirect_to predios_path
    else
      render 'new'
    end
  end


  private
    def predio_params
      params.require(:predio).permit(:name, :no_hectareas)
    end

    def require_same_user
      if current_user != @predio.user
        flash[:danger] = "Solo puedes editar tus propios predios"
        redirect_to predios_path
      end
    end
end