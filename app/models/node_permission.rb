class NodePermission < ActiveRecord::Base
  belongs_to :user
  belongs_to :node
  
  validate :node_must_exist
  validate :user_must_exist
  validate :must_be_unique
  
  attr_protected :id, :node_id
  
  private
  
  def node_must_exist
    errors.add(:node_id, 'invalid') unless Node.find_by_id(node_id)
  end
  
  def user_must_exist
    errors.add(:user_id, 'invalid') unless User.find_by_id(user_id)
  end
  
  def must_be_unique
    errors.add_to_base('Record exists.') if
      NodePermission.find_all_by_node_id_and_user_id(node_id, user_id).count > 0
  end
end
