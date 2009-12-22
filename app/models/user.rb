class User < ActiveRecord::Base
  has_many :posts
  has_many :tags, :through => :posts
  
  validates_length_of :login, :within => 3..32
  validates_length_of :password, :within => 5..64
  validates_presence_of :login, :email, :password, :password_confirmation
  validates_uniqueness_of :login, :email, :case_sensitive => false
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid format of email address."
  validates_confirmation_of :password
  
  attr_accessor :password, :password_confirmation
  attr_protected :id, :salt

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
  
  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass + salt)
  end
end
