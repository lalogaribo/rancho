class WorkersController < ApplicationController
  layout 'dashboard'
  before_action :set_worker, only: [:show, :edit, :update, :destroy]
  before_action :require_user, except: [:show]


  def index
    @workers = current_user.workers
  end

  def show
  end

  # GET /workers/new
  def new
    @worker = Worker.new
    @workerTypes = WorkerType.all
  end

  def edit
    @workerTypes = WorkerType.all
  end

  def create
    @worker = Worker.new(worker_params)
    @worker.user = current_user
    if @worker.save
      flash[:success] = "Se ha dado de alta el trabajador #{@worker.fullname}"
      redirect_to workers_path
    else
      @workerTypes = WorkerType.all
      render 'new'
    end
  end

  def update
    respond_to do |format|
      if @worker.update(worker_params)
        format.html {redirect_to workers_path, notice: "Se ha actualizado exitosamente el trabajador #{@worker.fullname}"}
        format.json {render :index, status: :ok}
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
    params.require(:worker).permit(:name, :last_name, :phone_number, :worker_type_id)
  end
end
