class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :blog
  has_and_belongs_to_many :tags

  validates_inclusion_of :post_type, :in => (1..6).to_a, :message => 'Undefined types!'
  
  attr_protected :id, :user_id, :session, :post_id
  
  before_save :fill_session

  protected
  
  def fill_session
    if p = Post.find_by_id(post_id)
      self.session = p.session
    else
      self.post_id = nil
      self.session = Digest::MD5.hexdigest(Time.now.to_f.to_s + User.random_string(5))
    end
  end
end