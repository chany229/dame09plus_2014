class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid_Commentable::Comment
  attr_accessible :body, :username
  field :body, :type => String
  field :username, :type => String
  field :url, :type => String
  field :email, :type => String
  belongs_to :user
end
