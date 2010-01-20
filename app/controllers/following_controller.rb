class FollowingController < ApplicationController
  before_filter :login_required
  
  # * <tt>GET /blogs/:id/following/new</tt>
  # * send me a HTTP get messsage to follow me ..
  def create
    respond_to do |format|
      if blog = Blog.find_by_name(params[:blog_id])
        begin
          @current_user.followings << blog
        rescue
        end
        format.html { redirect_to blog_path(blog.name) }
      else
        flash[:error] = 'No such blog.'
        format.html { redirect_to dashboard_url }
      end
    end
  end
  
  # * <tt>DELETE /blogs/:id/following</tt>
  # * send me a HTTP delete message to unfollow me ..
  def destroy
    respond_to do |format|
      if blog = Blog.find_by_name(params[:blog_id])
        begin
          @current_user.followings.delete(blog)
        rescue
        end
        format.html { redirect_to blog_path(blog.name) }
      else
        flash[:error] = 'No such blog.'
        format.html { redirect_to dashboard_url }
      end
    end
  end
end
