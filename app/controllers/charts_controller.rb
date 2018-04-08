class ChartsController < ApplicationController
  def index
    @predios = current_user.predios
  end

  def new_users
    render json: User.group_by_day(:created_at).count
  end

  def new_materials
    render json: current_user.materials.group_by_day(:created_at).count
  end

  def invertido_materials
    render json: current_user.materials.group(:name).sum(:quantity)
  end
end
