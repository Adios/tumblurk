# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def logged_in
    User.find_by_id(session[:user_id])
  end
end
