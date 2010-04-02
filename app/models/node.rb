class Node < ActiveRecord::Base
  has_many :children, :class_name => 'Node', :foreign_key => 'parent_id'
  belongs_to :parent, :class_name => 'Node'
  has_many :permissions, :class_name => 'NodePermission'
  has_many :mappings, :class_name => 'NodeMapping', :dependent => :destroy
  has_many :users, :through => :permissions
  has_many :blogs, :through => :mappings

  validates_presence_of :name
  validates_format_of :name, :with => /^[-$.+!*'(),\w]+$/, :message => "Invalid format."
  validate :name_must_be_unique_in_the_current_level

  attr_protected :id, :parent_id

  # test a user if one has the ability to admin the current node
  def granted? user
    current = self
    while current
      return true if current.users.include? user
      current = current.parent
    end
    nil
  end

  # test a path if it is in the tree.
  def self.routable? ns
    # move to root
    pos = Node.first
    # scan
    ns.each do |n|
      hit = false
      pos.children.each do |child|
        if child.name == n
          pos = child
          hit = true
          break
        end
      end
      return false if not hit
    end

    pos
  end

  protected

  def name_must_be_unique_in_the_current_level
    if self.parent
      self.parent.children.each do |node|
        next if node == self
        if name == node.name
          errors.add(:name, "must be unique in the current level.")
          return
        end
      end
    end
  end
end
