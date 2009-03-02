class Article < ActiveRecord::Base
  belongs_to :author, :polymorphic => true
  belongs_to :owner, :polymorphic => true

  acts_as_resource :per_page => 5
  acts_as_content :reflection => :owner
  acts_as_taggable

#  acts_as_versioned

  validates_presence_of :body
end
