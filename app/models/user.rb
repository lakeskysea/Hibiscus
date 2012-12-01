##
# This class is used to verify the format of email field.
class EmailValidator < ActiveModel::EachValidator
  ##
  # Verify if the +value+ of +attribute+ in a +record+ is a valid email address.
  #
  # If it is not a valid email, record in the error message.
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || "is not an email") unless
      value =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  end
end

##
# This class represents a actual user of Craftsmanship.
class User
  include Mongoid::Document
  include Mongoid::Slug
  include ActsAsVoter
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  # devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  include Gamify

  devise :omniauthable, :rememberable, :trackable, :database_authenticatable

  field :name, :type => String
  field :email, :type => String
  field :username, :type => String
  field :admin, :type => Boolean
  field :gravatar_email, :type=> String
  field :points, :type => Integer
  field :digest_frequency, :type => String
  field :referrer_username, :type => String

  slug :username

  acts_as_voter

  references_many :authentications, :dependent => :delete
  references_many :katas, :dependent => :delete
  references_many :posts, :dependent => :delete
  references_many :likes, :dependent => :delete
  embeds_one :plan

  # FIXME: Figure out how to make this reference work out.
  # references_many :comments, :through => :posts

  validates :username, :presence => true
  # validates :email, :email => true

  ##
  # Get a user name.
  def display_name
    self.name.blank? ? self.username : self.name
  end
end
