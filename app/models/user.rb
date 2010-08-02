# == Schema Information
# Schema version: 20100801154548
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  attr_accessor :password # creates virtual "password" attribute
  attr_accessible :name, :email, :password, :password_confirmation
  # http://railstutorial.org/chapters/modeling-and-viewing-users-one#code:validates_format_of_email
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, :presence => true,
                   :length   => { :maximum => 50 }
  validates :email, :presence => true,
                    :format   => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }

  # Automatically creates virtual attribute "password_confirmation"
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }

  before_save :encrypt_password

  # Return true if user's password matches submitted_password
  def has_password?(submitted_password)
    # Compare encrypted_password with the encrypted version of
    # submitted_password
    encrypted_password == encrypt(submitted_password)
  end

  private

    def encrypt_password
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      string # temporary!
    end
end
