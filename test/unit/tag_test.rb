require 'test_helper'

class TagTest < ActiveSupport::TestCase
  self.use_instantiated_fixtures = true
  
  test "name cannot be duplicated" do
    # not exists, try to hack id
    t = Tag.new :name => 'i am super man', :id => 999
    assert_difference 'Tag.count' do
      assert t.save
    end
    assert_not_equal 999, t.id
    # duplicated.
    t = Tag.new :name => @olympus.name
    assert_no_difference 'Tag.count' do
      assert !t.save
    end
    assert t.errors.invalid?('name')
  end
end
