class CreateTagsPosts < ActiveRecord::Migration
  def self.up
    create_table :posts_tags, :id => false do |t|
      t.references :post
      t.references :tag
    end
  end

  def self.down
    drop_table :posts_tags
  end
end
