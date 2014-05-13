class NewComment
  include Mongoid::Document
  include Mongoid::Timestamps
  attr_accessible :body, :username, :commentable_type, :commentable_id
  belongs_to :user
  belongs_to :commentable, :polymorphic => true
  field :body, :type => String
  field :username, :type => String
  field :url, :type => String
  field :email, :type => String
end