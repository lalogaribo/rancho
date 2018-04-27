class RequestsController < ApplicationController
  def index
    if current_user.admin?
      @requests = Request.all
    else
      @requests = current_user.requests
    end
  end

  def new
    @request = Request.new
  end

  def create
    @request = Request.new(request_params)
    @request.user = current_user
    if @request.save
      flash[:success] = 'Solicitud creada exitosamente'
      redirect_to vuelos_path
    else
      render 'new'
    end
  end


  private

  def request_params
    params.require(:request).permit(:user_id, :predio)
  end

  def set_request
    @request = Request.find(params[:id])
  end
end
