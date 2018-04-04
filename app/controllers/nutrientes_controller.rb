class NutrientesController < ApplicationController
  before_action :require_user, except: [:show]
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
    @nutriente = Nutriente.find(params[:id])
  end

  def edit
    @nutriente = Nutriente.find(params[:id])
  end

  def update
    @nutriente = Nutriente.find(params[:id])
    if @nutriente.update_attributes(nutriente_params)
      flash[:success] = 'Nutriente actualizado exitosamente'
      redirect_to nutrientes_url
    else
      render 'edit'
    end
  end

  def destroy
    Nutriente.find(params[:id]).destroy
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

end
