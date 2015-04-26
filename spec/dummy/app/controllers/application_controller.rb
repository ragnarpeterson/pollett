class ApplicationController < ActionController::Base
  include Pollett::Controller

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  def render_list(list)
    render json: list, status: :ok
  end
end
