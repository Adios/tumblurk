require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  test 'show posts tagged by official' do
    get :show, :id => '1'
    assert_equal 2, assigns(:posts).count
  end
end
