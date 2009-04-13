class Group < ActiveRecord::Base
  belongs_to :user
#  has_many :memberships, :as => :group
#  has_many :members, :through => :memberships

  has_many :articles,  :as => :owner
  has_many :photos,    :as => :owner
  has_many :audios,    :as => :owner
  has_many :bookmarks, :as => :owner
  has_many :documents, :as => :owner

  acts_as_resource :per_page => 15
  acts_as_container
  acts_as_stage
  acts_as_logoable

  # Collection aliases
  alias_attribute :title, :name

  validates_presence_of :name
  validates_uniqueness_of :name

  def local_affordances(options = {})
    affs = []
    if others_read_members?
      affs << ActiveRecord::Authorization::Affordance.new(Anyone.current, [:read, :member])
    end

    if others_write_members?
      affs << ActiveRecord::Authorization::Affordance.new(Anyone.current, [:create, :member])
    end

    affs
  end

end
