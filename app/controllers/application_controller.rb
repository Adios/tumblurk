# Note: all methods in the application are protected by using #protect_from_forgery.
class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  
  protected
  
  # * work as a filter for any other method that needs to be authencated.
  # * after passing through it, an instance variable -- <tt>@current_user</tt> will be set up.
  # * <tt>@current_user</tt> contains the #User instance of corresponded user id.   
  def login_required
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    else
      flash[:notice] = "Please log in"
      redirect_to root_url
    end
  end
  
  # redirect to user page if the session has been set.
  def redirect_logged
    redirect_to dashboard_url if session[:user_id]
  end
end
