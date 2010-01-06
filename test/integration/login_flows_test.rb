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
    assert_equal user_path(assigns(:user)), path
    # signed user want to log in.
    get_via_redirect new_session_path
    assert_equal user_path(assigns(:user)), path
    # signed user want to sign up again.
    get_via_redirect new_user_path
    assert_equal user_path(assigns(:user)), path
    # log out
    delete_via_redirect session_path
    assert_equal root_path, path
  end

  test "User login" do
    get new_session_path
    assert_response :success
    # log in failed
    post session_path, { :session => { :login => @adios.login, :password => 'testt' } }
    assert_response :success
    assert_nil session[:user_id]
    # log in
    post_via_redirect session_path, { :session => { :login => @adios.login, :password => 'testtest' } }
    assert_equal user_path(@adios), path
    # logged user want to log in again
    get_via_redirect new_session_path
    assert_equal user_path(@adios), path
    # logged user want to sign up again
    get_via_redirect new_user_path
    assert_equal user_path(@adios), path
    # logout
    delete_via_redirect session_path
    assert_equal root_path, path
    # logout user can access both login/signup pages
    get new_user_path
    assert_response :success
    get new_session_path
    assert_response :success
  end
end
