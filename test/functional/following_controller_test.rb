require 'test_helper'

class FollowingControllerTest < ActionController::TestCase
  def setup
    @cindera, @adios, @flachesis = users(:cindera), users(:cindera), users(:cindera)
  end
  
  test 'follow a blog' do
    # not loggin yet
    assert_no_difference 'blogs(:flachesis).followers.count' do
      post :create, { :blog_id => blogs(:flachesis).name }
    end
    assert_redirected_to root_url
    # logged
    assert_difference 'blogs(:flachesis).followers.count' do
      post :create, { :blog_id => blogs(:flachesis).name }, { :user_id => @cindera.id }
    end
    assert_redirected_to blog_path(blogs(:flachesis).name)
    # follow an existed one, trigger nothing.
    assert_no_difference 'blogs(:flachesis).followers.count' do
      post :create, { :blog_id => blogs(:flachesis).name }, { :user_id => @cindera.id }
    end
    assert_redirected_to blog_path(blogs(:flachesis).name)
    # follow self, nothing happended
    assert_no_difference 'blogs(:flachesis).followers.count' do
      post :create, { :blog_id => blogs(:flachesis).name }, { :user_id => @flachesis.id }
    end
    assert_redirected_to blog_path(blogs(:flachesis).name)
  end
  
  test 'unfollow a blog' do
    # not loggin yet
    assert_no_difference 'blogs(:adios).followers.count' do
      delete :destroy, { :blog_id => blogs(:adios).name }
    end
    assert_redirected_to root_url
    # logged
    assert_difference 'blogs(:adios).followers.count', -1 do
      delete :destroy, { :blog_id => blogs(:adios).name }, { :user_id => @cindera.id }
    end
    assert_redirected_to blog_path(blogs(:adios).name)
    # follow an unfollowed one, trigger nothing.
    assert_no_difference 'blogs(:adios).followers.count' do
      delete :destroy, { :blog_id => blogs(:adios).name }, { :user_id => @cindera.id }
    end
    assert_redirected_to blog_path(blogs(:adios).name)
  end    
end
