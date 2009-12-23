class AddRepostFeatureToPosts < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.column :session, :string
      t.references :post
    end
  end

  def self.down
    remove_column :posts, :session
    remove_column :posts, :post_id
  end
end
