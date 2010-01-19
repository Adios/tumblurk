class Post < ActiveRecord::Base  
  belongs_to :user
  belongs_to :blog
  has_and_belongs_to_many :tags
  has_many :replies, :class_name => 'Post', :foreign_key => 'origin_id'
  belongs_to :origin, :class_name => 'Post'

  validates_presence_of :blog_id, :user_id, :kind
  validates_inclusion_of :kind, :in => %w(text photo link blurk audio video), :message => 'invalid type!'
  validate_on_create :check_original_kind
  
  attr_protected :id, :user_id, :origin_id, :session, :kind
  before_create :fill_session

  protected
  
  def check_original_kind
    if origin and not origin.kind == kind
      errors.add('kind', 'invalid original type.')
      return false
    end
  end
  
  def fill_session
    if origin
      self.session = origin.session
    else
      self.session = Digest::MD5.hexdigest(Time.now.to_f.to_s + User.random_string(5))
    end
  end
end