require 'test_helper'

class MainControllerTest < ActionController::TestCase
  self.use_instantiated_fixtures = true

  test "login and logout" do
    # failure
    post :create, { :session => { :login => @adios.login, :password => '123123' } }
    assert_response :success
    assert_nil session[:user_id]
    # success
    post :create, { :session => { :login => @adios.login, :password => 'testtest' } }
    assert_redirected_to user_path(@adios)
    assert_equal session[:user_id], @adios.id
    # logout
    delete :destroy
    assert_redirected_to root_url
    assert_nil session[:user_id]
  end
end
