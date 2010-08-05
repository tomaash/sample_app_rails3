# == Schema Information
# Schema version: 20100804210439
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  validates :content, :length => { :maximum => 140 },
                      :presence => true
  validates :user_id, :presence => true

  default_scope :order => 'microposts.created_at DESC'

  def self.from_users_followed_by(user)
    followed_ids = user.following.map(&:id).join(', ')
    where("user_id IN (#{followed_ids}) OR user_id = ?", user)
  end
end
