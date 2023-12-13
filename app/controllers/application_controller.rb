class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?

  def current_user
    @__user__ ||= User.find_by(id: session[:__user_ticket__])
  end

  def user_signed_in?
    current_user.present?
  end
end
