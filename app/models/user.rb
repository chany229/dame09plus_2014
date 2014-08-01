# encoding: utf-8
class User
  include Mongoid::Document
  include Mongoid::Timestamps

  #rolify
  #attr_accessor :from

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  validates_presence_of :email
  validates_presence_of :encrypted_password

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
  # run 'rake db:mongoid:create_indexes' to create indexes
  index({ email: 1 }, { unique: true, background: true })
  field :username, :type => String
  validates :username, :uniqueness => { :case_sensitive => false }, :presence => true
  attr_accessor :login, :crop_x, :crop_y, :crop_w, :crop_h
  attr_accessible :login, :username, :email, :password, :password_confirmation, :remember_me, :created_at, :updated_at,
                  :crop_x, :crop_y, :crop_w, :crop_h

  #has_many :comments, :validate => false

  #def created_at
  #  read_attribute(:created_at) + 8.hours
  #end

  include Mongoid::Document::Roleable

  mount_uploader :avatar, AvatarUploader

  has_many :comments
  #has_many :commented_entrys, :through => :comments, :source => :commentable, :source_type => "Entry"
=begin
  has_many :be_followed, :as => :followable, :class_name => "Followship"
  has_many :followers, :through => :be_followed, :source => :user
  has_many :followship
  has_many :followed_demos, :through => :followship, :source => :followable, :source_type => 'Demo'
  has_many :followed_users, :through => :followship, :source => :followable, :source_type => 'User'
=end
  # fields ^


  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login).downcase
      where(conditions).where('$or' => [ {:username => /^#{Regexp.escape(login)}$/i}, {:email => /^#{Regexp.escape(login)}$/i} ]).first
    else
      where(conditions).first
    end
  end 

  before_create :init_roles
  def init_roles
    self.roles = []
  end
  after_update :crop_avatar
  def crop_avatar
    avatar.recreate_versions! if self.crop_x
  end


  def path=(value)
    self.avatar = ActionDispatch::Http::UploadedFile.new({
      :filename => value[:name],
      :type => value[:content_type],
      :head => nil,
      :tempfile => File.open(value[:path])
    })
  end

  def comments_by_commentable(type = Entry)
    comments = self.comments.desc(:created_at)
    commentables = comments.map { |c| if c.commentable.class == type then c.commentable else nil end }.compact.uniq
    result = commentables.map do |commentable|
      o = CommentsByCommentable.new
      o.commentable = commentable
      o.comments = comments.select { |c| c.commentable == commentable }
      o
    end
    result
  end

  def avatar_url(version)
    "#{self.avatar.url(version)}?#{Time.now.to_i}"
  end
end

class CommentsByCommentable
  attr_accessor :commentable, :comments
end