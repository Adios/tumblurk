# Provide user management functions.
class UsersController < ApplicationController
  before_filter :login_required, :only => %w(edit update destroy)

  def new
    @user = User.new
  end
  
  # <b>login required</b>
  def edit
    @user = @current_user
  end
  
  # * <tt>GET /users/[ID]</tt>
  # * send me a HTTP GET message to show the user information.
  # * e.g. GET users/1
  def show
    @user = User.find(params[:id])
  end
  
  # * <tt>POST /users</tt>
  # * send me a HTTP POST message to signup a new user.
  # * the message body should contains a +user+ field. 
  def create
    @user = User.new(params[:user])
    
    if @user.save
      reset_session
      session[:user_id] = @user.id
      @current_user = User.find(session[:user_id])
      flash[:notice] = 'Hi'
      redirect_to @user
    else
      render :new
    end
  end
  
  # * <tt>PUT /users/[ID]</tt>
  # * send me a HTTP PUT message to update user information.
  # * the message body should contains a +user+ field.
  # * the HTTP PUT message can be simulated using HTTP POST with a <tt>_method=PUT</tt> field.
  # * <b>login required</b>
  def update
    @user = @current_user
    
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Update successful!'
      redirect_to @user
    else
      render :edit
    end
  end
  
  # * <tt>DELETE /users/[ID]</tt>
  # * send me a HTTP DELETE message to delete the user.
  # * the HTTP DELETE message can be simulated using HTTP POST with a <tt>_method=DELETE</tt> field.
  # * <b>login required</b>
  def destroy
    @user = @current_user

    if @user.destroy
      reset_session
      flash[:notice] = 'You are terminated.'
      redirect_to root_url
    else
      redirect_to @user
    end
  end
end
