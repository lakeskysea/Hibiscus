require 'indextank'

class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning
  
  attr_accessor :tempTags
  
  field :title, :type => String
  field :content, :type => String
  field :isKata, :type => Boolean, :default => false
  
  key :title

  embeds_many :comments
  embeds_many :katacomments
  references_many :likes, :dependent => :destroy
  has_and_belongs_to_many :tags
  referenced_in :user

  validates :title, :presence => true
  validates :content, :presence => true
  validates :isKata, :inclusion => [true, false]
  validates :user_id, :presence => true
  
  def listLikes
    likes = []
    self.likes.each do |l|
      likes << l unless l.isDislike
    end
    
    return likes
  end
  
  def listDislikes
    dislikes = []
    self.likes.each do |l|
      dislikes << l if l.isDislike
    end
    
    return dislikes
  end

  def update_search_index(url)
    a = ENV['INDEXTANK_API_URL']
    api = IndexTank::Client.new(ENV['INDEXTANK_API_URL'] || '<API_URL>')
    index = api.indexes 'idx'
    index.document(url).add({ :title => self.title, :timestamp => self.created_at.to_i, :text => self.title + " " + self.content, :url => url, :id => self.id})
  end

end
