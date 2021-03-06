class MainController < ApplicationController
  before_filter :redirect_logged, :only => %w(index forgot create)
  before_filter :login_required, :only => %w(destroy dashboard dashboard_for_blog)
  
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
    @posts = @current_user.granted_posts
    @blogs = @current_user.blogs
    session[:current_blog] = nil
    render 'main', :layout => 'dashboard'
  end
  
  def dashboard_for_blog
    @blogs = @current_user.blogs
    
    if (blog = Blog.find_by_name(params[:name])) and blog.users.exists?(@current_user)
      @posts = blog.posts
      session[:current_blog] = blog.id
      render 'main', :layout => 'dashboard'
    else
      flash[:error] = "Blog doesn't exist or you didn't participate in."
      redirect_to dashboard_url
    end
  end
end
