require 'test_helper'

class LoginFlowsTest < ActionController::IntegrationTest
  fixtures :all
  
  def setup
    @adios = users(:adios)
  end
  
  test "User signup" do
    get new_user_path
    assert_response :success
    # signup failed
    post users_path, {}
    assert_response :success
    assert_nil session[:user_id]
    # signup
    post_via_redirect users_path, { :user => {
      :login => 'alison',
      :email => 'alison@alison.org',
      :password => 'alialiali',
      :password_confirmation => 'alialiali' } }
    assert_equal dashboard_path, path
    assert_equal assigns(:current_user).id, session[:user_id]
    # signed user want to log in.
    get_via_redirect root_url
    assert_equal dashboard_path, path
    assert_equal assigns(:current_user).id, session[:user_id]
    # signed user want to sign up again.
    get_via_redirect new_user_path
    assert_equal dashboard_path, path
    assert_equal assigns(:current_user).id, session[:user_id]
    # log out
    delete_via_redirect session_path
    assert_equal root_path, path
  end

  test "User login" do
    get root_url
    assert_response :success
    # log in failed
    post session_path, { :session => { :login => @adios.login, :password => 'testt' } }
    assert_response :redirect
    assert_nil session[:user_id]
    # log in
    post_via_redirect session_path, { :session => { :login => @adios.login, :password => 'testtest' } }
    assert_equal dashboard_path, path
    assert_equal assigns(:current_user).id, session[:user_id]
    # logged user want to log in again
    get_via_redirect root_url
    assert_equal dashboard_path, path
    assert_equal assigns(:current_user).id, session[:user_id]
    # logged user want to sign up again
    get_via_redirect new_user_path
    assert_equal dashboard_path, path
    assert_equal assigns(:current_user).id, session[:user_id]
    # logout
    delete_via_redirect session_path
    assert_equal root_path, path
    # logout user can access both login/signup pages
    get new_user_path
    assert_response :success
    get root_url
    assert_response :success
  end
end
