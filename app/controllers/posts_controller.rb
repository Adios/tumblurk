# Provide access to posts resources.
class PostsController < ApplicationController
  before_filter :login_required, :only => %w(create destroy update)
  
  # <tt>POST /posts</tt>
  # 
  # send me a HTTP POST message to create a new post.
  # currently only HTML response supported.
  def create
    @post = Post.new(params[:post])
    @post.user_id = @current_user.id
    
    respond_to do |format|
      if @post.save
        format.html { redirect_to @current_user }
      else
        format.html
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
          format.html { redirect_to @current_user }
        end
      else
        flash[:error] = 'Do not try to hack me >.^'
        format.html { redirect_to @current_user }
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
        if @post.update_attributes(params[:post])
          format.html { redirect_to @current_user }
        end
      else
        flash[:error] = 'I am watching you!'
        format.html { redirect_to @current_user }
      end
    end
  end
end