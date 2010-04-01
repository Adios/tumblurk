require 'test_helper'

class NodeTest < ActiveSupport::TestCase
  test "basic constraints" do
    n = Node.new
    assert !n.save
    n.name = '1'
    assert n.save
    n.name = '1234567890abzcdeuxzAASDV!.'
    assert n.save
    n.name = '[]'
    assert !n.save
  end

  test "uniquess in the same level" do
    n1 = Node.new :name => 'newnode'
    n1.parent = Node.first
    assert n1.save
    n2 = Node.new :name => 'newnode'
    n2.parent = Node.first
    assert !n2.save
    assert n2.errors.invalid?('name')
    n3 = Node.new :name => 'newnode'
    n3.parent = n1
    assert n3.save
  end

  test "access rights" do
    assert nodes(:root).granted? users(:winni)
    assert nodes(:epapers).granted? users(:adios)
    assert nodes(:epapers).granted? users(:winni)
    assert_nil nodes(:gais).granted? users(:adios)
    assert nodes(:gais).granted? users(:winni)
  end

  test "path including" do
    assert_equal Node.first, Node.routable?([])
    assert_equal Node.find_by_name('gais'), Node.routable?(['research', 'gais'])
    assert !Node.routable?(['gais'])
    assert_equal Node.find_by_name('master'), Node.routable?(['recruit', 'master'])
    assert !Node.routable?(['recruit', 'master', '1'])
  end
end
