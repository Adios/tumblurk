require 'test_helper'

class BlogsControllerTest < ActionController::TestCase
  def setup
    @adios = users(:adios)
    @cindera = users(:cindera)
    @flachesis = users(:flachesis)
  end
  
  test 'show' do
    get :show, { :name => blogs(:adios).name }
    assert assigns(:blog)
  end
  
  test 'create and destroy a group blog' do
    # create a blog.
    post :create, { :blog => { :name => 'olympus', :title => 'olympus user' } }, { :user_id => @adios.id }
    assert_response :redirect
    assert_redirected_to blog_path(assigns(:blog))
    # invite cindera.
    blog_id = Blog.find_by_name('olympus').id
    post :invite, { :id => blog_id, :user => { :login => @cindera.login } }, { :user_id => @adios.id }
    assert_response :redirect
    assert_redirected_to blog_path(assigns(:blog))
    # cindera invite flachesis
    post :invite, { :id => blog_id, :user => { :login => @flachesis.login } }, { :user_id => @cindera.id }
    assert_response :redirect
    assert_redirected_to blog_path(assigns(:blog))
    assert_equal 3, Blog.find_by_name('olympus').users.count
    # adios left
    assert_difference "Blog.find_by_name('olympus').users.count", -1 do
      delete :destroy, { :id => blog_id }, { :user_id => @adios.id }
      assert_response :redirect
    end
    # cindera left  
    assert_difference "Blog.find_by_name('olympus').users.count", -1 do
      delete :destroy, { :id => blog_id }, { :user_id => @cindera.id }
      assert_response :redirect
    end      
    # flachesis left
    delete :destroy, { :id => blog_id }, { :user_id => @flachesis.id }
    assert_response :redirect
    # no more
    assert_nil Blog.find_by_name('olympus')
  end
end
