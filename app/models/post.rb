class Post < ActiveRecord::Base
  belongs_to :author, :polymorphic => true

  belongs_to :postable, :polymorphic => true

  attr_protected :author, :author_id, :author_type,
    :postable, :postable_id, :postable_type

  validates_presence_of :postable_id, :postable_type, :author_id,
    :author_type, :text

  authorizing do |agent, permission|
    agent == author &&
      ( permission == :update || permission == :delete ) ||
      # Delegate delete to postable
      postable.present? &&
      permission == :delete &&
      postable.authorize?(:delete, :to => agent)
  end
end
