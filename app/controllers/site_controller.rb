class SiteController < ApplicationController
  def show
    if @node = Node.routable?(params[:path])
      @path = params[:path]
      @parent_path = '/' + params[:path].slice(0..-2).join('/')
      @children_path = lambda {|x| '/' + params[:path].dup.push(x).join('/') }
      @data = @node.blogs.map {|blog| blog.posts}.flatten.sort_by {|post| post.updated_at}
    else
      raise Exceptions::PageNotFound
    end
  end
end
