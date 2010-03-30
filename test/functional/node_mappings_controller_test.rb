require 'test_helper'

class NodeMappingsControllerTest < ActionController::TestCase
  def setup
    @winni = users(:winni)
    @node = Node.first
    @blog = Blog.find_by_name(@winni.login)
    @another_blog = Blog.find_by_name('adios')
  end

  test 'basic operations' do
    # successfully create a mapping
    assert_difference 'NodeMapping.count' do
      post :create, { :node_id => @node.id, :node_mapping => { :blog_id => @blog.id } }, { :user_id => @winni.id }
    end
    new_mapping = assigns(:mapping)
    # succesffuly update a mapping
    assert_no_difference 'NodeMapping.count' do
      put :update, { :node_id => @node.id, :id => new_mapping.id, :node_mapping => { :blog_id => @another_blog.id } }, { :user_id => @winni.id }
    end
    # successfully destroy a mapping
    assert_difference 'NodeMapping.count', -1 do
      delete :destroy, { :node_id => @node.id, :id => new_mapping.id }, { :user_id => @winni.id }
    end
    assert !NodeMapping.exists?(new_mapping)
  end
end
