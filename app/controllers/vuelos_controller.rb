class VuelosController < ApplicationController
  layout 'dashboard'
  before_action :set_vuelo, only: [:show, :edit, :update, :destroy]

  def index
    if logged_in? && current_user.admin?
      @vuelos = Vuelo.all
    else
      @vuelos = current_user.vuelos
    end
  end

  def new
    @vuelo = Vuelo.new
  end

  def create
    @vuelo = Vuelo.new(vuelo_params)
    if @vuelo.save
      flash[:success] = 'Vuelo dado de alta exitosamente'
      redirect_to vuelos_path
    else
      render 'new'
    end
  end

  def edit
  end

  def show
  end

  def update
    if @vuelo.update(vuelo_params)
      flash[:success] = 'Vuelo editado correctamente'
    else
      render 'edit'
    end
  end

  def destroy
    if @vuelo.destroy
      flash[:success] = 'Vuelo eliminado exitosamente'
      redirect_to vuelos_path
    end
  end

  private

  def vuelo_params
    params.require(:vuelo).permit(:user_id, :predio, :aplicacion, :piloto, :precio_vuelo)
  end

  def set_vuelo
    @vuelo = Vuelo.find(params[:id])
  end
end
