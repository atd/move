class Article < ActiveRecord::Base
  belongs_to :author, :polymorphic => true
  belongs_to :owner, :polymorphic => true
#  acts_as_content :per_page => 5
#  acts_as_versioned

#  validates_as_content
  validates_presence_of :body
end
