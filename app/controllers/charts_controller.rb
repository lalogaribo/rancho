class ChartsController < ApplicationController
  before_action :check_predio, only: [:index]
  layout 'dashboard'

  def index
    @predios = current_user.predios
    @predio_id = params[:predio_id]
    unless @predio_id.nil?
      @predio = Predio.find(@predio_id)
    end
  end

  private

  # @return [Object]
  def check_predio
    @predio_id = params[:predio_id]
    if @predio_id
      predio = current_user.predios.find_by(id: @predio_id)
      if predio.nil?
        flash[:danger] = "Solo puedes acceder a tus graficas."
        redirect_to predios_path
      end
    end
  end
end
