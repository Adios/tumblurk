class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_table :blogs do |t|
      t.string :name
      t.string :title
      t.string :description
      t.boolean :private
      t.boolean :default_blog
      t.timestamps
    end
    
    change_table :posts do |t|
      t.references :blog
    end
    
    create_table :blogs_users, :id => false do |t|
      t.references :user
      t.references :blog
    end
  end

  def self.down
    drop_table :blogs, :blogs_users
    remove_column :posts, :blog_id
  end
end
