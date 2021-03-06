class InfoPredioController < ApplicationController
  layout 'dashboard'
  before_action :set_info_predio, only: [:show, :edit, :update, :destroy]
  before_action :same_user, only: [:show, :edit, :update, :destroy]

  def index
    @predio_id = params[:id]
    unless @predio_id.nil?
      @info_predios = InfoPredio.includes(:predio).find_by(predio_id: @predio_id).order(created_at: :desc)
    else
      @info_predios = InfoPredio.includes(:predio).where(user_id: current_user.id).order(created_at: :desc)
    end
  end

  def new
    @predio_id = params[:id]
    @week = Date.parse(current_date).strftime('%W')
    @user = current_user
    @materials = current_user.materials.where(name: ['rafia', 'bolsa', 'cinta'])
    @info_predios = InfoPredio.where(predio_id: @predio_id, user_id: current_user.id)
    predio_week = InfoPredio.where(semana: @week, predio_id: @predio_id).where('created_at BETWEEN ? AND ?', DateTime.now.beginning_of_year, DateTime.now.end_of_day).first
    unless @materials.present?
      flash[:danger] = 'No has dado de alta ningun tipo de materiales (Rafia, Bolsa y Cinta). Agrega materiales para continuar.'
      redirect_to materials_path
    end

    redirect_to edit_info_predio_path(predio_week.id) unless predio_week.nil?

    @info_predio = InfoPredio.new
  end

  def create
    @predio_id = params[:predio_id]
    @info_predio = InfoPredio.new(info_predio_params)

    if @info_predio.save
      #pago Workers
      savePagoTrabajadores

      #otros_pagos
      saveOtrosPagos

      #Materiales
      saveMaterials

      flash[:success] = 'Informacion del predio guardada exitosamente'
      @predio = params[:info_predio]
      @predio_id = @predio['predio_id']
      @predio = Predio.find(@predio_id)
      redirect_to predio_info_predio_index_path(@predio)
    else
      @predio = params[:info_predio]
      @predio_id = @predio['predio_id']
      @week = Date.parse(current_date).strftime('%W')
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

    @info_predio = InfoPredio.includes(:material, :otros_gasto, :predio, :worker)
                       .find(@info_predio_id)
    @detalle = @info_predio.info_predio_detalle
    @otros_pagos = @info_predio.otros_gasto
    @workers = @info_predio.worker
    @pagos_workers = @info_predio.info_predio_workers
    @predio = @info_predio.predio
  end

  def update
    @info_predio = InfoPredio.find(params[:id])
    if @info_predio.update_attributes(info_predio_params)
      #materials
      updateMaterials

      #remove pago workers
      removePagoWorkers

      #add nuevos pagos workers
      savePagoTrabajadores

      #otros_pagos remove
      removeOtrosGastos

      #add otros_pagos
      saveOtrosPagos

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
    flash[:success] = 'Nutriente eliminado'
    redirect_to nutrientes_url
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def info_predio_params
    @params1 = params.require(:info_predio).permit(:predio_id, :semana, :user_id,
                                        :fumigada, :color_cinta,
                                        :conteo_racimos, :fecha_embarque,
                                        :precio, :venta, :nutriente, :ratio, :pago_trabaja)
  end

  def savePagoTrabajadores
    workers = params[:trabajador_id]
    pagoWorkers = params[:pago_trabajador]

    unless workers.nil?
      workers.each_with_index do |id, index|
        pago = pagoWorkers[index]
        precio = pago.to_i
        pagoWorker = InfoPredioWorker.new(worker_id: id, precio: precio)
        pagoWorker.info_predio = @info_predio
        pagoWorker.save
      end
    end
  end

  def saveOtrosPagos
    otros_pagos = params[:otro_pago]
    precio_otros_pagos = params[:otro_pago_precio]

    unless otros_pagos.nil?
      otros_pagos.each_with_index do |otro_pago, index|
        precio = precio_otros_pagos[index]
        otroGasto = OtrosGasto.new(nombre: otro_pago, precio: precio)
        otroGasto.info_predio = @info_predio
        otroGasto.save
      end
    end
  end

  def saveMaterials
    materials = params[:material]
    materials_qty = params[:material_quantity]

    unless materials.nil?
      materials.each_with_index do |material, index|
        id = material
        qty = materials_qty[index]
        infoMaterial = InfoPredioDetalle.new(material_id: id, cantidad: qty)
        infoMaterial.info_predio = @info_predio

        # update inventory
        next unless infoMaterial.save
        materialRow = Material.find(material)
        old_qty = materialRow.quantity.to_i
        new_qty = old_qty - qty.to_i
        materialRow.quantity = new_qty
        materialRow.save
      end
    end
  end

  def updateMaterials
    predio_material_ids = params[:material_predio_hd]
    materials_qty = params[:material_quantity]
    materials_qty_old = params[:material_quantity_old]
    unless predio_material_ids.nil?
      predio_material_ids.each_with_index do |predio_material_id, index|
        info_predio_detalle = InfoPredioDetalle.find_by(id: predio_material_id)
        qty = materials_qty[index]
        qty_save_old = materials_qty_old[index]
        next unless info_predio_detalle.update_attributes(cantidad: qty)
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
    end
  end

  def removeOtrosGastos
    otros_pagos_remove = params[:otros_pagos_removed]
    unless otros_pagos_remove.nil?
      otros_pagos_remove.each_with_index do |otro_pago, index|
        remove_otro_pago = OtrosGasto.find_by(id: otro_pago)
        remove_otro_pago.destroy
      end
    end
  end

  def removePagoWorkers
    otros_pagos_remove = params[:pagos_trabajadores_removed]
    unless otros_pagos_remove.nil?
      otros_pagos_remove.each_with_index do |otro_pago, index|
        remove_otro_pago = InfoPredioWorker.find_by(id: otro_pago)
        remove_otro_pago.destroy
      end
    end
  end

  def info_predio_nutrientes_params
    params.require(:info_predio).permit(:nutriente_id)
  end

  def current_date
    Time.now.strftime('%Y-%m-%d') # Week from monday to monday
  end

  def set_info_predio
    @info_predio = InfoPredio.find(params[:id])
  end

  def same_user
    if current_user != @info_predio.user
      flash[:danger] = 'Solo puedes editar o borrar tu informacion'
      redirect_to predios_path
    end
  end
end
