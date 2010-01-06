require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @adios = users(:adios)
    @post_one = posts(:adios)
  end

  test 'create posts' do
    # out of type
    p = Post.new :post_type => 100, :head => 'hi', :body => 'lo'
    p.user_id = @adios.id
    assert !p.save
    assert p.errors.invalid?('post_type')
    # create a post, session must be uniqueness
    p = Post.new :post_type => 1, :head => 'hi', :body => 'lo'
    p.user_id = @adios.id
    assert p.save
    assert p.session
    assert_equal 1, Post.find_all_by_session(p.session).count
  end
  
  test 'create a re-post' do
    # a valid re-post
    p = Post.new :post_type => 1, :head => 'a', :body => 'b'
    p.post_id = @post_one.id
    assert p.save!
    assert_equal @post_one.id, p.post_id
    assert_equal @post_one.session, p.session
    # any invalid post id will be treated as a fresh post.
    p = Post.new :post_type => 1, :head => 'a', :body => 'c'
    p.post_id = 10000000000
    assert p.save!
    assert_nil p.post_id
    assert p.session
    assert_equal 1, Post.find_all_by_session(p.session).count
    # even if the refered post had been deleted
    p = Post.new :post_type => 1, :head => 'a', :body => 'c'
    p.post_id = @post_one.id
    assert @post_one.destroy
    assert p.save!
    assert_nil p.post_id
    assert p.session
    assert_not_equal @post_one, p.session
    assert_equal 1, Post.find_all_by_session(p.session).count
  end
end
