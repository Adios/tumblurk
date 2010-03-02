class NodeMapping < ActiveRecord::Base
  belongs_to :blog
  belongs_to :node
  belongs_to :tag
  
  validate :blog_must_exist
  validate :node_must_exist
  validate :tag_must_exist, :unless => "tag_id.nil?"
  validate :must_be_unique
  
  attr_protected :id, :node_id

  private
  
  def blog_must_exist
    errors.add(:blog_id, "invalid") unless Blog.find_by_id(blog_id)
  end
  
  def node_must_exist
    errors.add(:node_id, "invalid") unless Node.find_by_id(node_id)
  end
  
  def tag_must_exist
    errors.add(:tag_id, "invalid") unless Tag.find_by_id(tag_id)
  end
  
  def must_be_unique
    errors.add_to_base('Record exists.') if
      NodeMapping.find_all_by_blog_id_and_node_id_and_tag_id(blog_id, node_id, tag_id).count > 0
  end
end
