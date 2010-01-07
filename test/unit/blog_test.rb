require 'test_helper'

class BlogTest < ActiveSupport::TestCase
  test 'remove wamgl should also remove the posts' do
    count = Post.count
    assert_difference 'Blog.count', -1 do
      assert Blog.find_by_name('wamgl').destroy
    end
    assert_not_equal count, Post.count
  end
  
  test 'default blog cannot be deleted / be a group' do
    blog = blogs(:adios)
    assert !blog.destroy
    assert blog.errors.invalid?('default_blog')
    blog.users << users(:cindera)
    assert !blog.save
    assert blog.errors.invalid?('default_blog')
  end
  
  test 'group blog' do
    # adios create a new blog
    blog = Blog.new :title => 'my group', :name => 'gaislab'
    blog.users << users(:adios)
    assert blog.save
    # cindera came to join
    blog.users << users(:cindera)
    assert blog.save
    assert_equal 2, blog.users.count
    # default blog cannot be group blog
    blog = blogs(:adios)
    assert blog.save
    blog.users << users(:cindera)
    assert !blog.save
  end
  
  test 'invalid blog name will be declined' do
    # presence
    blog = Blog.new :title => 'heelo', :description => 'world'
    assert !blog.save
    assert blog.errors.invalid?('name')
    # duplicate
    blog.name = 'wamgl'
    assert !blog.save
    assert blog.errors.invalid?('name')
    # too short
    blog.name = 'w'
    assert !blog.save
    assert blog.errors.invalid?('name') 
    # too long
    blog.name = 'wamgl' * 100
    assert !blog.save
    assert blog.errors.invalid?('name')
    # not chars
    blog.name = 'abcd.123'
    assert !blog.save
    assert blog.errors.invalid?('name')
    # valid
    blog.name = 'abc-123'
    assert blog.save
  end
  
  test 'protected attributes cannot be modified' do
    blog = Blog.new :id => 100, :default_blog => true, :name => 'coolblog'
    assert blog.save
    assert_not_equal 100, blog.id
    assert_not_equal true, blog.default_blog?
  end
  
  test 'group blog should be destroyed as no one inside' do
    assert blogs(:wamgl).users.delete(users(:adios))
    assert blogs(:wamgl).users.delete(users(:cindera))
    assert_difference 'Blog.count', -1 do
      assert blogs(:wamgl).save
    end
  end
end
