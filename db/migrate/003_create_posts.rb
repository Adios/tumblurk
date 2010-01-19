class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :kind # text, photo, link, blurk, audio, video
      t.text :head
      t.text :body
      t.boolean :visible, :default => true
      t.timestamps
      t.timestamp :publish_at
      t.references :user
    end
  end

  def self.down
    drop_table :posts
  end
end
