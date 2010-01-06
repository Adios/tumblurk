class Blog < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :posts, :dependent => :destroy
  
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  validates_length_of :name, :within => 3..64
  validates_format_of :name, :with => /^[-a-zA-Z0-9]+$/, :message => 'Invalid name.'
  
  attr_protected :id, :default_blog
  
  before_destroy :default_blog_cannot_be_deleted
  before_save :default_blog_cannot_be_a_group
  
  protected 
  
  def default_blog_cannot_be_deleted
    if default_blog
      errors.add(:default_blog, 'cannot be deleted!')
      return false
    end
  end
  
  def default_blog_cannot_be_a_group
    if default_blog and users.count > 1
      errors.add(:default_blog, 'cannot be a group!')
      return false
    end
  end
end
