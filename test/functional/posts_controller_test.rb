require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  test "create post" do
    # not logged in
    assert_no_difference 'Post.count' do
      post :create
    end
    assert_response :redirect
    # logged in
    assert_difference 'Post.count' do
      post :create, { :post => { :post_type => '1' } }, { :user_id => @adios.id }
    end
    assert_response :redirect
  end

  test "delete a post" do
    assert_no_difference 'Post.count' do
      # not logged in
      delete :destroy, { :id => '1' }
      assert_response :redirect
      # not owner
      delete :destroy, { :id => '1' }, { :user_id => @cindera.id }
      assert_response :redirect
      assert flash[:error]
    end
    assert_difference 'Post.count', -1 do
      delete :destroy, { :id => '1' }, { :user_id => @adios.id }
    end
  end
    
  test "update a post" do
    assert_no_difference 'Post.count' do
      # not logged in
      put :update, { :id => '1' }
      assert_response :redirect
      assert_redirected_to root_url
      # no the owner
      put :update, { :id => '1' }, { :user_id => @cindera.id }
      assert_response :redirect
      assert flash[:error]
      # successful updating
      put :update, { :id => '1', :post => { :head => 'kkk' } },  { :user_id => @adios.id }
      assert_response :redirect
      assert_equal 'kkk', Post.first.head
    end
  end
end
