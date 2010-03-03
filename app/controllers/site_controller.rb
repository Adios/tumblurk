class SiteController < ApplicationController
  def show
    if @node = Node.include?(params[:path])
      @path = params[:path] 
      @children_path = lambda {|x| params[:path].join('/') + '/' + x}
      @parent_path = params[:path].slice(0..-2).join('/')
      @content = @node.content
      @data = @node.blogs.map {|blog| blog.posts}.flatten.sort_by {|post| post.updated_at}
    else
      raise Exceptions::PageNotFound
    end
  end
end
