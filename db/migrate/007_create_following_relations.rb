class CreateFollowingRelations < ActiveRecord::Migration
  def self.up
    create_table :following_relations, :force => true, :id => false do |t|
      t.references :user
      t.references :blog
    end
  end

  def self.down
    drop_table :following_relations
  end
end
