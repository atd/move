class Post < ActiveRecord::Base
  belongs_to :author, :polymorphic => true

  belongs_to :postable, :polymorphic => true

  attr_protected :author, :author_id, :author_type,
    :postable, :postable_id, :postable_type

  validates_presence_of :postable_id, :postable_type, :author_id,
    :author_type, :text

  acl_set do |acl, post|
    acl << [ post.author, :update ]
    acl << [ post.author, :delete ]
    post.postable.acl.entries.select{ |ace| ace.action?(:delete) }.each { |ace|
      acl << ace
    } if post.postable.present?
  end
end
