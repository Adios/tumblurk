require 'test_helper'

class NodesControllerTest < ActionController::TestCase
  def setup
    @root = Node.first
    @winni = users(:winni)
  end

  test 'basic operations on node controller' do
    # successfully create a node.
    assert_difference 'Node.count' do
      assert_difference '@root.children.count' do
        post :create, { :node => { :name => 'newnode', :parent_id => @root.id } }, { :user_id => @winni.id }
      end
    end
    new_node = assigns(:node)
    assert_response :redirect
    assert_redirected_to node_path(new_node)
    # successfully move the node to one of its siblings.
    assert_no_difference 'Node.count' do
      assert_difference '@root.children.count', -1 do
        assert_difference '@root.children.first.children.count' do
          put :update, { :id => new_node.id, :node => { :name => 'newnode', :parent_id => @root.children.first.id } }, { :user_id => @winni.id }
        end
      end
    end
    assert_response :redirect
    assert_redirected_to node_path(new_node)
    # successfully delete a node.
    assert_difference 'Node.count', -1 do
      assert_difference '@root.children.first.children.count', -1 do
        delete :destroy, { :id => new_node.id }, { :user_id => @winni.id }
      end
    end
    assert_response :redirect
    assert_redirected_to nodes_path
    assert !Node.exists?(new_node)
  end
end
