require 'test_helper'
require 'digest/sha1'

class UserTest < ActiveSupport::TestCase
  test 'encrypt() & hashed generation' do
    u = User.new :login => 'soida', :email => 'adios@adios.com'
    u.salt = '1000'
    u.password = u.password_confirmation = 'valid_password'
    assert u.save
    assert_equal Digest::SHA1.hexdigest('valid_password1000'), u.hashed_password
    assert_equal Digest::SHA1.hexdigest('valid_password1000'), User.encrypt('valid_password', '1000')
  end

  test 'random_string()' do
    new_pass = User.random_string(10)
    assert_not_nil new_pass
    assert_equal 10, new_pass.length
  end

  test 'protected attributes' do
    u = User.new :id => 99999, :salt => 'hack', :login => 'soida', :email => 'valid@valid.com'
    u.password = u.password_confirmation = 'validpass'
    assert u.save
    assert_not_equal 99999, u.id
    assert_not_equal 'hack', u.salt
    u.update_attributes :id=> 99999, :salt => 'hack2', :login => 'soida2', :email => 'valid2@valid.com'
    assert u.save
    assert_not_equal 99999, u.id
    assert_not_equal 'hack2', u.salt
    assert_equal 'soida2', u.login
  end

  test 'authentication' do
    assert_equal @adios, User.authenticate('adios', 'testtest')
    # wrong username and/or password.
    assert_nil User.authenticate('cindera', 'test1234')
    assert_nil User.authenticate('soida', 'testtest')
    assert_nil User.authenticate('abc', 'wrongpassword')
  end
  
  test 'change password' do
    assert_equal @cindera, User.authenticate('cindera', 'testtest')
    # change password
    @cindera.password = @cindera.password_confirmation = 'thisisnewpassword'
    assert @cindera.save
    # new password works, old password dosen't.
    assert_equal @cindera, User.authenticate('cindera', 'thisisnewpassword')
    assert_nil User.authenticate('cindera', 'testtest')
  end
  
  test 'disallowed passwords' do
    u = User.new :login => 'newuser', :email => 'newuser@new.com'
    # too short
    u.password = u.password_confirmation = 'shor'
    assert !u.save
    assert u.errors.invalid?('password')
    # too long
    u.password = u.password_confirmation = 'huge' * 100
    assert !u.save
    assert u.errors.invalid?('password')
    # empty
    u.password = u.password_confirmation = ''
    assert !u.save
    assert u.errors.invalid?('password')
    # ok
    u.password = u.password_confirmation = 'a_valid_password'
    assert u.save
    assert u.errors.empty?
  end

  test 'login & email' do
    u = User.new :email => 'valid@valid.com'
    u.password = u.password_confirmation = 'a_valid_password'
    # too short
    u.login = 'h'
    assert !u.save
    assert u.errors.invalid?('login')
    # too long
    u.login = 'huge' * 100
    assert !u.save
    assert u.errors.invalid?('login')
    # empty
    u.login = ''
    assert !u.save
    assert u.errors.invalid?('login')
    # ok
    u.login = 'valid_login'
    assert u.save
    assert u.errors.empty?
    # no email
    u.email = nil
    assert !u.save
    assert u.errors.invalid?('email')
    # invalid email
    u.email = 'notavalidemail'
    assert !u.save
    assert u.errors.invalid?('email')
  end
  
  test 'login and email can not be duplicated' do
    u = User.new :login => 'Adios', :email => 'AdiosF6F@gmail.com'
    u.password = u.password_confirmation = 'validpassword'
    assert !u.save
    assert u.errors.invalid?('email')
    assert u.errors.invalid?('login')
  end
  
  test 'new user creation' do
    u = User.new :login => 'soida', :email => 'soida@gmail.com'
    u.password = u.password_confirmation = 'validpassword'
    assert_not_nil u.salt
    assert u.save
    assert_equal 10, u.salt.length
    assert_equal u, User.authenticate(u.login, u.password)
  end
=begin not set up mailer yet.
  test 'send_new_password' do
    assert_equal @adios, User.authenticate('adios', 'testtest')
    # send new password
    sent = @adios.send_new_password
    assert_not_nil sent
    # old password no longer worked
    assert_nil User.authenticate('adios', 'testtest')
    # email sholud already be sent
    assert_equal 'Your password is ...', sent.subject
    assert_equal @adios.email, sent.to[0]
    assert_math Regexp.new('Your username is adios.'), sent.body
    # new password works
    new_pass = $1 if Regexp.new('Your new password is (\\w+).') =~ sent.body
    assert_not_nil new_pass
    assert_equal @adios, User.authenticate('adios', new_pass)
    end
  end
=end
end