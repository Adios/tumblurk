module PostsHelper
  def exists id
    Post.find_by_id(id)
  end
end
