require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @adios = users(:adios)
    @cindera = users(:cindera)
    @post_one = posts(:adios)
  end

  test 'create posts' do
    # type error, no blog, no user
    p = Post.new :post_type => 100, :head => 'hi', :body => 'lo'
    assert !p.save
    assert p.errors.invalid?('post_type')
    assert p.errors.invalid?('blog_id')
    assert p.errors.invalid?('user_id')
    # create a post, session must be uniqueness
    p = Post.new :post_type => 1, :head => 'hi', :body => 'lo'
    p.user = @adios
    p.blog = blogs(:adios)
    assert p.save
    assert p.session
    assert_equal 1, Post.find_all_by_session(p.session).count
  end
  
  test 'create a re-post' do
    # a valid re-post
    p = Post.new :post_type => 1, :head => 'a', :body => 'b'
    p.origin = @post_one
    p.user = @cindera
    p.blog = blogs(:cindera)
    assert p.save!
    assert_equal @post_one.id, p.origin.id
    assert_equal @post_one.session, p.session
    # the refered post had been deleted
    count = Post.find_all_by_session(@post_one.session).count
    assert_difference 'Post.count', -1 do
      assert @post_one.destroy
    end
    assert p.reload
    assert_nil p.origin
    assert_equal @post_one.session, p.session
    assert_not_equal count, Post.find_all_by_session(@post_one.session).count
  end
  
  test 'update a post' do
    # session shoudn't be modified
    original_session = @post_one.session
    @post_one.head = 'b'
    assert @post_one.save
    assert_equal original_session, @post_one.session
  end
end
