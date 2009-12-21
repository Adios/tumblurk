require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  self.use_instantiated_fixtures = true
  
  test 'editing user information requires authenticaion' do
    # not logged in
    get :edit, { :id => @adios.id }
    assert_response :redirect
    assert_redirected_to root_url
    # logged in
    get :edit, { :id => @adios.id }, { :user_id => @adios.id }
    assert_response :success
    assert_equal assigns(:user).id, @adios.id
    # not the owner
    get :edit, { :id => @adios.id }, { :user_id => @cindera.id }
    assert_response :success
    assert_equal assigns(:user).id, @cindera.id
  end

  test 'user signup serivce' do
    # sign up for an existing login name
    assert_no_difference 'User.count' do
      post :create, { :user => { :login => @adios.login } }
    end
    # sign up 
    assert_difference 'User.count' do
      post :create, { :user => { 
        :login => 'alison',
        :password => 'alisonisthebest', 
        :password_confirmation => 'alisonisthebest', 
        :email => 'alison@alison.org' }
      }, { :user_id => @adios.id }
    end
    assert_response :redirect
    assert_redirected_to assigns(:user)
    assert session[:user_id]
    assert_not_equal session[:user_id], @adios.id
  end
  
  test 'update user information' do
    # not logged in
    put :update, { :id => @cindera.id }
    assert_redirected_to root_url
    # logged in, and try to hack somebody.
    assert_no_difference 'User.count' do
      put :update, { :id => @cindera.id, :user => { 
        :login => 'alison',
        :password => 'testtest',
        :password_confirmation => 'testtest',
        :email => 'alison@alison.org' } }, { :user_id => @adios.id }
    end
    assert_response :redirect
    assert_equal assigns(:user).login, 'alison'
    assert_equal assigns(:user).id, @adios.id
  end
  
  test 'delete user' do
    # not logged in
    assert_no_difference 'User.count' do
      delete :destroy, { :id => @cindera.id }
    end
    assert_redirected_to root_url
    # logged in, and try to hack somebody.
    assert_difference('User.count', -1) do
      delete :destroy, { :id => @cindera.id }, { :user_id => @adios.id }
    end
    assert_redirected_to root_url
    assert_nil session[:user_id]
    assert_not_nil User.find(@cindera)
    assert !User.exists?(@adios), 'adios is terminated.'
  end
end
