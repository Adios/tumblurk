require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @adios = users(:adios)
    @cindera = users(:cindera)
    @post_one = posts(:adios)
  end

  test 'create posts' do
    # no kind, no blog, no user
    p = Post.new :head => 'hi', :body => 'lo'
    p.kind = 'blah'
    assert !p.save
    assert p.errors.invalid?('kind')
    assert p.errors.invalid?('blog_id')
    assert p.errors.invalid?('user_id')
    # create a post, session must be uniqueness
    p = Post.new :head => 'hi', :body => 'lo'
    p.kind = 'text'
    p.user = @adios
    p.blog = blogs(:adios)
    assert p.save
    assert p.session
    assert_equal 1, Post.find_all_by_session(p.session).count
  end
  
  test 'create a re-post' do
    # an invalid re-post
    p = Post.new :head => 'a', :body => 'b'
    p.kind = 'photo'
    p.origin = @post_one # which is a text post
    p.user = @cindera
    p.blog = blogs(:cindera)
    assert !p.save
    assert p.errors.invalid?('kind')
    # a valid re-post
    p.kind = @post_one.kind
    assert p.save
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
