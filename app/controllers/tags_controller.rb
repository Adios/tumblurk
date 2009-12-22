# Provide access points to tagged posts.
class TagsController < ApplicationController
  # * <tt>GET /tags/[ID]</tt>
  # * show posts tagged by the specified id.
  def show
    tag = Tag.find(params[:id])
    
    respond_to do |format|
      if not tag.nil?
        @posts = tag.posts
        format.html
      end
    end
  end
end
