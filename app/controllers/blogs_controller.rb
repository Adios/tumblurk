class BlogsController < ApplicationController
  before_filter :login_required, :except => %w(show)
  
  def new
    @blog = Blog.new
    render :layout => 'dashboard'
  end
  
  # display the blog of the given <b>name</b>. 
  # e.g. <tt>/blogs/soida</tt> will show up the blog which is named <b>soida</b>.
  def show
    @blog = Blog.find_by_name(params[:id])
    
    if @blog.nil?
      flash[:error] = "Blog doesn't exist!"
      redirect_to root_url
    end
  end
  
  # create <b>private</b> or <b>group</b> blogs.
  #
  # accept parameters: <tt>POST + params[:blog]</tt>
  def create
    @blog = Blog.new params[:blog]
    @blog.users << @current_user
    
    if @blog.save
      redirect_to blog_path(@blog.name)
    else
      render :new, :layout => 'dashboard'
    end
  end
  
  def edit
    @blog = Blog.find_by_name(params[:id])
    
    if @blog.nil?
      redirect_to dashboard_path
    else
      render :new, :layout => 'dashboard'
    end
  end
  
  # to leave the current blog. 
  # if a blog contains no members, it will be destroyed automatically later.
  #
  # <tt>DELETE /blogs/:id</tt>
  def destroy
    @blog = Blog.find_by_name(params[:id])
    
    respond_to do |format|
      if @blog.default_blog?
        flash[:message] = 'You cannot quit your own blog.'
      elsif @blog.users.exists? @current_user
        @blog.users.delete @current_user
        @blog.save
        flash[:message] = 'You are not the member of the group anymore.'
      else
        flash[:message] = 'You are already out.'
      end
      
      format.html { redirect_to dashboard_path }
    end
  end
  
  # update the settings of the current blog.
  #
  # accept parameters: <tt>PUT + params[:blog]</tt>
  def update
    @blog = Blog.find_by_name(params[:id])
    
    respond_to do |format|
      if @blog.users.exists?(@current_user)
        if @blog.update_attributes(params[:blog])
          flash[:notices] = 'Ok'
          format.html { redirect_to dashboard_blog_path(@blog.name) }
        else
          redirect_to dashboard_url
        end
      else
        flash[:notices] = 'You are not the member of this blog.'
        format.html { redirect_to dashboard_url }
      end
    end
  end
  
  # invite somebody to this blog.
  #
  # <tt>POST /blogs/:id/invite</tt>
  # accept parameters: <tt>params[:user][:login]</tt>
  def invite
    @blog = Blog.find_by_name(params[:id])
    @user = User.find_by_login(params[:user][:login])
    
    respond_to do |format|
      if @blog.nil?
        flash[:message] = 'No such blog.'
        format.html { redirect_to dashboard_path }
      elsif @user.nil?
        flash[:message] = "User doesn't exist."
        format.html { redirect_to dashboard_blog_path(@blog.name) }
      elsif @blog.users.exists?(@current_user)
        if @blog.default_blog?
          flash[:message] = "You cannot invite others to your own blog."
          format.html { redirect_to dashboard_blog_path(@blog.name) }
        elsif @blog.users.exists?(@user)
          flash[:message] = "User has been the member of the group."
          format.html { redirect_to dashboard_blog_path(@blog.name) }
        else
          @blog.users << @user
          @blog.save
          flash[:message] = 'Invited!'
          format.html { redirect_to dashboard_blog_path(@blog.name) }
        end
      else
        format.html { redirect_to dashboard_path }
      end
    end
  end
end
