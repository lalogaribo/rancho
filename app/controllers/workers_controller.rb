class WorkersController < ApplicationController
  layout 'dashboard'
  before_action :set_worker, only: [:show, :edit, :update, :destroy]
  access producer: {except: [:destroy]}, site_admin: :all
  before_action :require_same_user, except: [:edit, :update, :index]


  def index
    @workers = current_user.workers
  end

  def show
  end

  # GET /workers/new
  def new
    @worker = Worker.new
  end

  def edit
  end

  def create
    @worker = Worker.new(worker_params)
    @worker.user = current_user
    if @worker.save
      flash[:success] = "Se a dado de alta el trabajador #{@worker.name}"
      redirect_to workers_path
    else
      render 'new'
    end
  end

  def update
    respond_to do |format|
      if @worker.update(worker_params)
        format.html {redirect_to @worker, notice: 'Trabajador actualizado exitosamente'}
        format.json {render :show, status: :ok, location: @worker}
      else
        format.html {render :edit}
        format.json {render json: @worker.errors, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @worker.destroy
    respond_to do |format|
      format.html {redirect_to workers_url, notice: 'Trabajador eliminado exitosamente '}
      format.json {head :no_content}
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_worker
    @worker = Worker.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def worker_params
    params.require(:worker).permit(:name, :last_name, :phone_number)
  end
end
