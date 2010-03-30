require 'test_helper'

class NodePermissionsControllerTest < ActionController::TestCase
  def setup
    @winni = users(:winni)
    @adios = users(:adios)
    @cindera = users(:cindera)
    @node = Node.first
  end

  test 'basic operations' do
    # successfully create a permission
    assert_difference 'NodePermission.count' do
      post :create, { :node_id => @node.id, :node_permission => { :user_id => @adios.id } }, { :user_id => @winni.id }
    end
    new_permission = assigns(:permission)
    # succesffuly update a permission
    assert_no_difference 'NodePermission.count' do
      put :update, { :node_id => @node.id, :id => new_permission.id, :node_permission => { :user_id => @cindera.id } }, { :user_id => @winni.id }
    end
    # successfully destroy a permission
    assert_difference 'NodePermission.count', -1 do
      delete :destroy, { :node_id => @node.id, :id => new_permission.id }, { :user_id => @winni.id }
    end
    assert !NodePermission.exists?(new_permission)
  end

end
