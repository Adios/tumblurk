class CreateNodePermissions < ActiveRecord::Migration
  def self.up
    create_table :node_permissions do |t|
      t.references :user
      t.references :node
    end
  end

  def self.down
    drop_table :node_permissions
  end
end
