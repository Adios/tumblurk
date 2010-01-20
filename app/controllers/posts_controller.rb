# Provide access to posts resources.
class PostsController < ApplicationController
  before_filter :login_required, :except => %w(show)
  
  def new
    @post = Post.new
    @post.kind = params[:type]
    
    if session[:current_blog]
      @post.blog = Blog.find(session[:current_blog])
    else
      @post.blog = @current_user.blogs.first
    end
    
    render :layout => 'dashboard'
  end
  
  def repost
    @post = Post.new
    
    begin
      @post.origin = Post.find(params[:id])
      @post.kind = @post.origin.kind
      render :new, :layout => 'dashboard'
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'No refereed post.'
      redirect_to dashboard_url
    end
  end
  
  def show
    @post = Post.find(params[:id])
    @blog = @post.blog
    render 'blogs/show'
  end
  
  def edit
    @post = Post.find(params[:id])
    redirect_to dashboard_url unless @current_user == @post.user
    
    render :new, :layout => 'dashboard'
  end
  
  # <tt>POST /posts</tt>
  # 
  # send me a HTTP POST message to create a new post.
  # currently only HTML response supported.
  def create
    @post = Post.new(params[:post])
    @post.user = @current_user
    @post.origin = Post.find_by_id(params[:post][:origin_id])
    @post.kind = params[:post][:kind]    
    
    respond_to do |format|
      begin
        @post.blog = Blog.find(params[:post][:blog_id])
        @post.blog.users.find(@current_user)
        
        if @post.valid? and @post.save!
          format.html { redirect_to dashboard_url }
        else
          format.html { render :new, :layout => 'dashboard' }
        end
      rescue ActiveRecord::RecordNotFound
        flash[:error] = 'You have no permission to post to this blog.'
        format.html { redirect_to dashboard_url }
      end
    end
  end
  
  # <tt>DELETE /posts/[ID]</tt>
  # 
  # send me a HTTP DELETE message to delete a post.
  # HTTP DELETE can be simulated using a HTTP POST with <tt>_method=DELETE</tt>
  # currently only HTML response supported.  
  def destroy
    @post = Post.find(params[:id])
    
    respond_to do |format|
      if @post.user == @current_user
        if @post.destroy
          format.html { redirect_to dashboard_url }
        end
      else
        flash[:error] = 'Do not try to hack me >.^'
        format.html { redirect_to dashboard_url }
      end
    end
  end
  
  # <tt>PUT /posts/[ID]</tt>
  # 
  # send me a HTTP PUT message to update a post.
  # HTTP PUT can be simulated using a HTTP POST with <tt>_method=PUT</tt>
  # currently only HTML response supported.  
  def update
    @post = Post.find(params[:id])
    
    respond_to do |format|
      if @post.user == @current_user
        @post.update_attributes(params[:post])
      else
        flash[:error] = 'I am watching you!'
      end
      
      format.html { redirect_to dashboard_url }
    end
  end
end
