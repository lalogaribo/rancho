class PrediosController < ApplicationController

  def index
    @predios = Predio.all
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
end