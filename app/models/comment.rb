class Comment < ActiveRecord::Base
  belongs_to :author, :polymorphic => true
  belongs_to :commentable, :polymorphic => true

  attr_protected :author, :author_id, :author_type,
    :commentable, :commentable_id, :commentable_type

  validates_presence_of :commentable_id, :commentable_type, :author_id,
    :author_type, :content

  def local_affordances
    [ ActiveRecord::Authorization::Affordance.new(author, :update) ] +
      commentable.affordances.select{ |a| a.action?(:delete) }
  end
end
