class MaterialsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  layout 'dashboard'
  before_action :require_user, except: [:show]
  #before_action :require_same_user, except: [:index, :show]

  def index
    @materials = current_user.materials
  end

  def new
    @material = Material.new
  end

  def create
    @material = Material.new(material_params)
    @material.user = current_user
    if @material.save
      flash[:success] = "Se a dado de alta el producto #{@material.name}"
      redirect_to materials_path
    else
      render 'new'
    end
  end

  def edit
  end

  def show
  end

  def update
    if @material.update(material_params)
      flash[:success] = "Producto a sido actualizado"
      redirect_to @material
    else
      render 'edit'
    end
  end

  def destroy
    if @material.destroy
      flash[:danger] = 'Producto ha sido eliminado exitosamente'
      redirect_to materials_path
    end
  end

  private

  def material_params
    params.require(:material).permit(:name, :price, :quantity)
  end

  def set_product
    @material = Material.find(params[:id])
  end
end