require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test 'create posts' do
    # out of type
    p = Post.new :post_type => 100, :head => 'hi', :body => 'lo'
    p.user_id = @adios.id
    assert !p.save
    assert p.errors.invalid?('post_type')
    # create a post
    p = Post.new :post_type => 1, :head => 'hi', :body => 'lo'
    p.user_id = @adios.id
    assert p.save
  end
end
