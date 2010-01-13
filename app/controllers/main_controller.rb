class MainController < ApplicationController
  before_filter :redirect_logged, :only => %w(index forgot create)
  before_filter :login_required, :only => %w(destroy dashboard)
  
  def index
  end
  
  def new
    @user = User.new
  end
  
  # * <tt>POST /session</tt>
  # * send a HTTP POST message to me to create a session. (log in)
  # * <tt>session[login]</tt> and <tt>session[password]</tt> fields should be included in the message body.
  def create
    reset_session
    u = User.authenticate(params[:session][:login], params[:session][:password])
    
    if u
      reset_session
      session[:user_id] = u.id
      session[:user_login] = u.login
      @current_user = User.find(session[:user_id])
      flash[:notice] = 'hi, again!'
      redirect_to dashboard_url
    else
      flash[:error] = 'Invalid login or password.'
      redirect_to root_url
    end
  end
  
  # * <tt>DELETE /session</tt>
  # * send a HTTP DELETE message to me to destroy a session. (log out)
  # * the HTTP DELETE message can be simulated useing HTTP POST with <tt>_method=DELETE</tt> message.
  def destroy
    reset_session
    flash[:notice] = "You've been logged out."
    redirect_to root_url
  end
  
  # * <tt>POST /session/forgot</tt>
  # * send a HTTP POST message to me to reset password.
  # * <tt>user[email]</tt> should be included in the message.
  # * Note: this mechanism is currently *insecure*.
  def forgot
    u = User.find_by_email(params[:user][:email])
    if u and u.send_new_password
      flash[:message] = 'A new password has been sent by email.'
      redirect_to root_url
    else
      flash[:error] = "Couldn't send password."
    end
  end
  
  def dashboard
    @posts = Post.all :order => 'created_at DESC'
    @blogs = @current_user.blogs
    render 'main', :layout => 'dashboard'
  end
end
