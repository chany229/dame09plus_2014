class Entry
  include Mongoid::Document
  include Mongoid::Timestamps
  field :short, :type => String
  field :long,  :type => String
  validates_presence_of :short
end