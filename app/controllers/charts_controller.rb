class ChartsController < ApplicationController
  layout 'dashboard'
  
  def index
    @predios = current_user.predios
    @predio_id = params[:predio_id]
    unless @predio_id.nil?
      @predio = Predio.find(@predio_id)
    end
  end
end
