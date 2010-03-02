require 'test_helper'

class NodeMappingTest < ActiveSupport::TestCase
  test 'validation' do
    n = NodeMapping.new
    # do not allow empty save
    assert !n.save
    # fake blog_id
    n.blog_id = 100000000000
    n.node_id = 1
    assert !n.save
    assert n.errors.invalid?('blog_id')
    # fake node_id
    n.blog_id = 1
    n.node_id = 100000000000
    assert !n.save
    assert n.errors.invalid?('node_id')
    # fake tag_id
    n.blog_id = 1
    n.node_id = 1
    n.tag_id = 100
    assert !n.save
    assert n.errors.invalid?('tag_id')
    # duplicated
    n.tag_id = 3
    n.blog_id = 6
    n.node_id = 2
    assert !n.save
    assert !n.errors.invalid?('tag_id')
    assert !n.errors.invalid?('blog_id')
    assert !n.errors.invalid?('node_id')
    # pass!
    n = NodeMapping.new
    n.blog_id = 7
    n.node_id = 2
    assert n.save
  end
end
