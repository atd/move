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
  alias_attribute :author, :user

  validates_presence_of :name, :user
  validates_uniqueness_of :name

  after_create :create_author_performance

  authorizing do |agent, permission|
    permission == [ :read, :performance ] && others_read_members? ||
      permission == [ :create, :performance ] && ! agent.is_a?(SingularAgent)
  end

  def users
    actors.select{ |a| a.is_a?(User) }
  end

  def notification_email
    email.present? ?
      email :
      users.map(&:email).join(', ')
  end

  private

  # Create Performance for the author with the highest role
  def create_author_performance
    Performance.create! :stage => self,
                        :agent => author,
                        :role => self.class.roles.sort.last
  end

end
