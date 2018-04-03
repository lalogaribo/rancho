class PagesController < ApplicationController
  def index
    if logged_in?
      redirect_to root_path
      #redirect_to user_path(current_user)
    end
  end
end
