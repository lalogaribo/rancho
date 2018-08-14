class InfoPredioController < ApplicationController
  layout 'dashboard'
  before_action :set_info_predio, only: [:show, :update, :destroy]

  def index
    @predio_id = params[:id]
    @info_predios = if @predio_id.nil?
                      InfoPredio.includes(:predio).where(user_id: current_user.id)
                    else
                      InfoPredio.includes(:predio).find_by(predio_id: @predio_id)
    end
  end

  def new
    @predio_id = params[:id]
    @week = Date.parse(current_date).strftime("%W")
    @user = current_user
    @materials = current_user.materials.where(name: ['rafia', 'bolsa', 'cinta'])
    @info_predios = InfoPredio.where(predio_id: @predio_id, user_id: current_user.id)
    predio_week = InfoPredio.find_by(semana: @week, predio_id: @predio_id)

    unless @materials.present?
      flash[:danger] = 'No has dado de alta ningun tipo de materiales (Rafia, Bolsa y Cinta). Agrega materiales para continuar.'
      redirect_to materials_path
    end

    unless predio_week.nil?
      redirect_to edit_info_predio_path(predio_week.id)
    end

    @info_predio = InfoPredio.new
  end

  def create
    @predio_id = params[:predio_id]
    @info_predio = InfoPredio.new(info_predio_params)

    if @info_predio.save
      #otros_pagos
      @otros_pagos = params[:otro_pago]
      @precio_otros_pagos = params[:otro_pago_precio]

      unless @otros_pagos.nil?
        @otros_pagos.each_with_index {|otro_pago, index|
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
        @materials.each_with_index {|material, index|
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

  def edit
    @info_predio_id = params[:id]
    @nutrientes = Nutriente.all
    @user = current_user
    @materials = current_user.materials.where(name: ['rafia', 'bolsa', 'cinta'])

    @info_predio = InfoPredio.includes(:material, :otros_gasto, :predio)
                       .find(@info_predio_id)
    @detalle = @info_predio.info_predio_detalle
    @otros_pagos = @info_predio.otros_gasto
    @predio = @info_predio.predio
  end

  def update
    @info_predio = InfoPredio.find(params[:id])
    if @info_predio.update_attributes(info_predio_params)
      #materials
      @predio_material_hd = params[:material_predio_hd]
      @materials_qty = params[:material_quantity]
      @materials_qty_old = params[:material_quantity_old]
      unless @predio_material_hd.nil?
        @predio_material_hd.each_with_index {|predio_material_id, index|
          info_predio_detalle = InfoPredioDetalle.find_by(id: predio_material_id)
          qty = @materials_qty[index]
          qty_save_old = @materials_qty_old[index]
          if info_predio_detalle.update_attributes(cantidad: qty)
            # update inventory
            qty = qty.to_i - qty_save_old.to_i
            material = Material.find(info_predio_detalle.material_id)
            old_qty = material.quantity.to_i
            if qty >= 0
              new_qty = old_qty - qty.to_i
            else
              new_qty = old_qty + qty.abs
            end
            material.quantity = new_qty
            material.save
          end
        }
      end

      #otros_pagos remove
      @otros_pagos_remove = params[:otros_pagos_removed]
      unless @otros_pagos_remove.nil?
        @otros_pagos_remove.each_with_index {|otro_pago, index|
          remove_otro_pago = OtrosGasto.find_by(id: otro_pago)
          remove_otro_pago.destroy
        }
      end
      #new otros_pagos
      @otros_pagos = params[:otro_pago]
      @precio_otros_pagos = params[:otro_pago_precio]

      unless @otros_pagos.nil?
        @otros_pagos.each_with_index {|otro_pago, index|
          @precio = @precio_otros_pagos[index]
          @otroGasto = OtrosGasto.new({:nombre => otro_pago, :precio => @precio})
          @otroGasto.info_predio = @info_predio
          @otroGasto.save
        }
      end
      flash[:success] = 'Informacion del predio actualiza exitosamente'
      redirect_to info_predio_index_url
    else
      render 'edit'
    end
  end


  def show
    @info_predios = InfoPredio.all
  end

  def destroy
    @nutriente.destroy
    flash[:success] = "Nutriente eliminado"
    redirect_to nutrientes_url
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def info_predio_params
    params.require(:info_predio).permit(:predio_id, :semana, :user_id, :fumigada, :pago_trabaja, :color_cinta, :conteo_racimos, :fecha_embarque, :precio, :venta, :nutriente)
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
