class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :blog
  has_and_belongs_to_many :tags
  has_many :replies, :class_name => 'Post', :foreign_key => 'origin_id'
  belongs_to :origin, :class_name => 'Post'

  validates_inclusion_of :post_type, :in => (1..6).to_a, :message => 'Undefined types!'
  validates_presence_of :blog_id, :user_id
  
  attr_protected :id, :user_id, :origin_id, :session
  
  before_create :fill_session

  protected
  
  def fill_session
    if origin
      self.session = origin.session
    else
      self.session = Digest::MD5.hexdigest(Time.now.to_f.to_s + User.random_string(5))
    end
  end
end