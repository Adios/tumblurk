class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :post_type # 1 .. 6:  text, photo, link, blurk, audio, video
      t.text :head
      t.text :body
      t.binary :visible, :default => true
      t.timestamps
      t.timestamp :publish_at
      t.references :user
    end
  end

  def self.down
    drop_table :posts
  end
end