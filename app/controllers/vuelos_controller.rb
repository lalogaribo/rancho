class VuelosController < ApplicationController
  def index
    @vuelos = current_user.vuelos
  end

  def new
    @vuelo = Vuelo.new
  end
end
