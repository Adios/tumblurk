class CreateNodeMappings < ActiveRecord::Migration
  def self.up
    create_table :node_mappings do |t|
      t.references :tag
      t.references :node
      t.references :blog
    end
  end

  def self.down
    drop_table :node_mappings
  end
end
