require 'test_helper'

class NodePermissionTest < ActiveSupport::TestCase
  test 'validation' do
    p = NodePermission.new
    # do not allow empty save
    assert !p.save
    # fake node
    p.node_id = 100
    p.user_id = 1
    assert !p.save
    assert p.errors.invalid?('node_id')
    # fake user
    p.node_id = 1
    p.user_id = 100000
    assert !p.save
    assert p.errors.invalid?('user_id')
    # duplicate
    p.node_id = 1
    p.user_id = 4
    assert !p.save
    # pass
    p.node_id = 1
    p.user_id = 2
    assert p.save
  end
end
