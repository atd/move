class Post < ActiveRecord::Base
  belongs_to :author, :polymorphic => true

  belongs_to :postable, :polymorphic => true

  attr_protected :author, :author_id, :author_type,
    :postable, :postable_id, :postable_type

  validates_presence_of :postable_id, :postable_type, :author_id,
    :author_type, :text

  authorizing do |agent, permission|
    if agent == author && ( permission == :update || permission == :delete )
      true
    elsif postable.present? && permission == :delete
      # Delegate delete to postable
      postable.authorize?(:delete, :to => agent)
    end
  end

  def container
    postable
  end

  def author_for(agent)
    author
  end

  def last_action
    created_at == updated_at ? 'published' : 'modified'
  end
end
