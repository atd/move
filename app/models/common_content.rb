module CommonContent
  class << self
    def included(base)
      base.class_eval do
        alias_attribute :name, :title

        belongs_to :author, :polymorphic => true
        belongs_to :owner, :polymorphic => true

        acts_as_content :reflection => :owner
        acts_as_taggable

        has_many :comments,
                 :as => :commentable,
                 :dependent => :destroy

        attr_accessor :notification, :notification_text
      end
    end
  end

  def local_affordances
    affs = []
    if public_read?
      affs << ActiveRecord::Authorization::Affordance.new(Anyone.current, :read)
    end

    affs << ActiveRecord::Authorization::Affordance.new(Authenticated.current, [ :create, :comment])
    affs
  end

  def notification?
    self.notification.present? && self.notification != '0'
  end
end
