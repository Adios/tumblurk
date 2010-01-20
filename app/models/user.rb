class User < ActiveRecord::Base
  has_many :posts
  has_many :tags, :through => :posts
  has_and_belongs_to_many :blogs
  has_and_belongs_to_many :followings, :class_name => 'Blog', :join_table => 'following_relations',
                          :association_foreign_key => 'blog_id',
                          :foreign_key => 'user_id',
                          :before_add => [ :cannot_follow_myself, :cannot_follow_existed ]
  
  validates_presence_of :login, :email, :password, :password_confirmation
  validates_confirmation_of :password
  validates_uniqueness_of :login, :email, :case_sensitive => false
  validates_length_of :login, :within => 3..32
  validates_length_of :password, :within => 5..64
  validates_format_of :login, :with => /^[-a-zA-Z0-9]+$/, :message => "Invalid format of login."
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid format of email address."
  
  attr_accessor :password, :password_confirmation
  attr_protected :id, :salt
  
  after_create :create_default_blog
  before_destroy :destroy_all_blogs

  # user.posts + user.followings.posts + user.blogs.posts
  def granted_posts 
    (((ps ||= []) << posts) << followings.collect {|blog| blog.posts }) << blogs.collect {|blog| blog.posts }
    ps.flatten.uniq.sort_by {|post| post.created_at }.reverse!
  end

  def password=(pass)
    @password = pass
    self.salt = User.random_string(10) unless self.salt?
    self.hashed_password = User.encrypt(pass, self.salt)
  end
  
  def send_new_password
    new_pass = User.random_string(10)
    self.password = self.password_confirmation = new_pass
    self.save
    # Not set-up mailer yet.
    #Notifications.deliver_forgot_password(self.email, self.login, new_pass)
  end
  
  def self.authenticate(login, pass)
    u = find :first, :conditions => ['login = ?', login]
    return u if u and User.encrypt(pass, u.salt) == u.hashed_password
    nil
  end
  
  def self.random_string(len)
    chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    newpass = ''
    1.upto(len) { |i| newpass << chars[rand(chars.size - 1)]}
    return newpass
  end
    
  protected
  
  def destroy_all_blogs
    blogs.each { |b| b.delete }
    blogs.clear
  end
  
  def create_default_blog
    blog = Blog.new :name => login
    blog.default_blog = true
    blog.users << self
    blog.save
  end
  
  def cannot_follow_existed(blog)
    raise if followings.exists? blog
  end
  
  def cannot_follow_myself(blog)
    raise if blog == self.blogs.find_by_default_blog(true)
  end
  
  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass + salt)
  end
end
