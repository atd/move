class Post < ActiveRecord::Base
  belongs_to :author, :polymorphic => true

  belongs_to :postable, :polymorphic => true

  attr_protected :author, :author_id, :author_type,
    :postable, :postable_id, :postable_type

  validates_presence_of :postable_id, :postable_type, :author_id,
    :author_type, :text

  def local_affordances
    [ ActiveRecord::Authorization::Affordance.new(author, :update),
      ActiveRecord::Authorization::Affordance.new(author, :delete) ] +
      postable.affordances.select{ |a| a.action?(:delete) }
  end
end
