module CommonContent
  class << self
    def included(base)
      base.class_eval do
        alias_attribute :name, :title

        belongs_to :author, :polymorphic => true
        belongs_to :owner, :polymorphic => true

        acts_as_content :reflection => :owner
        acts_as_taggable

        has_many :posts,
                 :as => :postable,
                 :dependent => :destroy

        attr_accessor :notification, :notification_text

        authorizing :public_read_auth
        authorizing :authenticated_post_auth
      end
    end
  end

  def public_read_auth(agent, permission)
    if permission == :read && public_read?
      true
    end
  end

  def authenticated_post_auth(agent, permission)
    if permission == [ :create, :post ] && ! agent.is_a?(SingularAgent)
      true
    end
  end

  def notification?
    self.notification.present? && self.notification != '0'
  end

  # The author for this content taking into account Group privacy settings
  def author_for(agent)
    case owner
    when Group
      owner.authorize?([ :read, :performance ], :to => agent) ?
        author :
        owner
    else
      author
    end
  end

  def title!
    title.present? && title ||
      "#{ I18n.t( self.class.to_s.underscore, :count => 1 ) } #{ to_param }" 
  end
end
