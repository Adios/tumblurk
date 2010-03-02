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
  
  test "access rights" do
    assert nodes(:root).granted? users(:winni)
    assert nodes(:epapers).granted? users(:adios)
    assert nodes(:epapers).granted? users(:winni)
    assert_nil nodes(:gais).granted? users(:adios)
    assert nodes(:gais).granted? users(:winni)
  end
  
  test "path including" do
    assert_equal Node.find_by_name(nil), Node.include?([])
    assert_equal Node.find_by_name('gais'), Node.include?(['research', 'gais'])
    assert !Node.include?(['gais'])
    assert_equal Node.find_by_name('master'), Node.include?(['recruit', 'master'])
    assert !Node.include?(['recruit', 'master', '1'])
  end
end
