class InfoPredioController < ApplicationController
  before_action :set_info_predio, only: [:show, :edit, :update, :destroy]

  def index
    @info_predios = InfoPredio.all
  end

  def new
    @predio_id = params[:id]
    @week = Date.parse(current_date).strftime("%W")
    @nutrientes = Nutriente.all
    @user = current_user
    @info_predio = InfoPredio.new
  end

  def create
    @predio_id = params[:predio_id]
    @info_predio = InfoPredio.new(info_predio_params)

    if @info_predio.save
      infoNutriente = InfoPredioNutriente.new(info_predio_nutrientes_params)
      infoNutriente.info_predio = @info_predio
      infoNutriente.save

      flash[:success] = 'Informacion del predio guardada exitosamente'
      redirect_to info_predio_index_url
    else
      @week = Date.parse(current_date).strftime("%W")
      @nutrientes = Nutriente.all
      @user = current_user
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @nutriente.update_attributes(info_predio_params)
      flash[:success] = 'Informacion del predio guardada exitosamente'
      redirect_to info_predio_index_url
    else
      render 'edit'
    end
  end

  def destroy
    @nutriente.destroy
    flash[:success] = "Nutriente eliminado"
    redirect_to nutrientes_url
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def info_predio_params
      params.require(:info_predio).permit(:predio_id, :semana, :user_id, :fumigada, :pago_trabaja, :color_cinta, :conteo_racimos)
    end

    def info_predio_nutrientes_params
      params.require(:info_predio).permit(:nutriente_id)
    end

    def current_date 
      Time.now.strftime("%Y-%m-%d") # Week from monday to monday
    end

    def set_info_predio
      @info_predio = InfoPredio.find(params[:id])
    end

end
