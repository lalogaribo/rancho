class InfoPredioController < ApplicationController
  before_action :set_info_predio, only: [:show, :update, :destroy]

  def index
    @info_predios = InfoPredio.all
  end

  def new
    @predio_id = params[:id]
    @week = Date.parse(current_date).strftime("%W")
    @nutrientes = Nutriente.all
    @user = current_user
    @materials = current_user.materials.where(name: ['rafia','bolsa','cinta'])
    @info_predios = InfoPredio.all

    predio_week = InfoPredio.where(semana: @week)
    if predio_week.empty?
      @info_predio = InfoPredio.new
    else
      redirect_to edit_info_predio_path(@predio_id)
    end
    @info_predio = InfoPredio.new
  end

  def create
    @predio_id = params[:predio_id]
    @info_predio = InfoPredio.new(info_predio_params)

    if @info_predio.save
      #Nutriente
      infoNutriente = InfoPredioNutriente.new(info_predio_nutrientes_params)
      infoNutriente.info_predio = @info_predio
      infoNutriente.save

      #otros_pagos
      @otros_pagos = params[:otro_pago]
      @precio_otros_pagos = params[:otro_pago_precio]

     unless @otros_pagos.nil? 
        @otros_pagos.each_with_index { |otro_pago, index|
          @precio = @precio_otros_pagos[index]
          @otroGasto = OtrosGasto.new({:nombre => otro_pago, :precio => @precio})
          @otroGasto.info_predio = @info_predio
          @otroGasto.save
        }
      end

      #Materiales
      @materials = params[:material]
      @materials_qty = params[:material_quantity]

      unless @materials.nil? 
        @materials.each_with_index { |material, index|
          @id = material
          @qty = @materials_qty[index]
          @infoMaterial = InfoPredioDetalle.new({:material_id => @id, :cantidad => @qty})
          @infoMaterial.info_predio = @info_predio

          # update inventory
          if @infoMaterial.save
            material = Material.find(material)
            old_qty = material.quantity.to_i
            new_qty = old_qty - @qty.to_i
            material.quantity = new_qty
            material.save
          end
        }
      end

      flash[:success] = 'Informacion del predio guardada exitosamente'
      @predio = params[:info_predio]
      @predio_id = @predio['predio_id']
      @predio = Predio.find(@predio_id)
      redirect_to predio_info_predio_index_path(@predio)
    else
      @predio = params[:info_predio]
      @predio_id = @predio['predio_id']
      @week = Date.parse(current_date).strftime("%W")
      @nutrientes = Nutriente.all
      @user = current_user
      @materials = Material.all
      @info_predios = InfoPredio.all
      render 'new'
    end
  end

  def show
    @info_predios = InfoPredio.all
  end

  def edit
    @predio_info_id = params[:id]
    @week = Date.parse(current_date).strftime("%W")
    @nutrientes = Nutriente.all
    @user = current_user
    @materials = current_user.materials.where(name: ['rafia','bolsa','cinta'])

    @info_predio = InfoPredio.includes(:nutriente, :material)
                          .find(@predio_info_id)
                        
    @detalle =  @info_predio.info_predio_detalle
    @nutriente_predio = @info_predio.info_predio_nutriente
    
    #abort @nutriente.inspect
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
      params.require(:info_predio).permit(:predio_id, :semana, :user_id, :fumigada, :pago_trabaja, :color_cinta, :conteo_racimos, :fecha_embarque, :precio, :venta)
    end

    def info_predio_nutrientes_params
      params.require(:info_predio).permit(:nutriente_id)
    end

    def current_date 
      Time.now.strftime("%Y-%m-%d") # Week from monday to monday
    end

    def set_info_predio
      @info_predio = InfoPredio.where(id: params[:id])
    end
end
