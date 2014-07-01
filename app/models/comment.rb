class Comment
    include Mongoid::Document
    store_in collection: 'new_comments'
    include Mongoid::Timestamps
    attr_accessible :body, :username, :commentable_type, :commentable_id
    belongs_to :user
    belongs_to :commentable, :polymorphic => true
    field :body, :type => String
    field :username, :type => String
    field :url, :type => String
    field :email, :type => String

    def nickname
        if self.user
            self.user.username
        else
            self.username
        end
    end
end