class NutrientesController < ApplicationController
  layout 'dashboard'
  before_action :set_nutriente, only: [:show, :edit, :update, :destroy]

  def index
    @nutrientes = Nutriente.all
  end
  
  def new
    @nutriente = Nutriente.new
  end

  def create
    @nutriente = Nutriente.new(nutriente_params)
    if @nutriente.save
      flash[:success] = 'Nutriente creado exitosamente'
      redirect_to nutrientes_url
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @nutriente.update_attributes(nutriente_params)
      flash[:success] = 'Nutriente actualizado exitosamente'
      redirect_to nutrientes_url
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
    def nutriente_params
      params.require(:nutriente).permit(:nombre, :precio)
    end

    def current_date 
      Time.now.strftime("%Y-%m-%d") # Week from monday to monday
    end

    def set_nutriente
      @nutriente = Nutriente.find(params[:id])
    end

end
