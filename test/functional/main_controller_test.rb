require 'test_helper'

class MainControllerTest < ActionController::TestCase
  def setup
    @adios = users(:adios)
    @dashboard_path = '/dashboard'
  end
  
  test "login and logout" do
    # failure
    post :create, { :session => { :login => @adios.login, :password => '123123' } }
    assert_response :redirect
    assert_nil session[:user_id]
    # success
    post :create, { :session => { :login => @adios.login, :password => 'testtest' } }
    assert_redirected_to @dashboard_path
    assert_equal assigns(:current_user).id, session[:user_id]
    assert_equal session[:user_id], @adios.id
    # logout
    delete :destroy
    assert_redirected_to root_url
    assert_nil session[:user_id]
  end
end
