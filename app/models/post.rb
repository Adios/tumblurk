class Post < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :tags

  validates_inclusion_of :post_type, :in => (1..6).to_a, :message => 'Undefined types!'
  validates_presence_of :user_id
  
  attr_protected :id, :user_id
end