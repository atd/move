class Group < ActiveRecord::Base
  belongs_to :parent, :class_name => "Group", :foreign_key => 'parent_id'
  has_many :children, :class_name => "Group", :foreign_key => 'parent_id'

  belongs_to :user

  has_many :articles,  :as => :owner
  has_many :photos,    :as => :owner
  has_many :audios,    :as => :owner
  has_many :bookmarks, :as => :owner
  has_many :documents, :as => :owner
  has_many :tasks,     :as => :owner
  has_many :events,    :as => :owner

  has_many :tags, :as => :container

  acts_as_resource :per_page => 15
  acts_as_container :sources => true,
                    :contents => [ :articles, :photos, :audios, :bookmarks, :documents, :tasks, :events ]
  acts_as_stage
  acts_as_logoable

  # Collection aliases
  alias_attribute :title, :name
  alias_attribute :author, :user

  validates_presence_of :name, :user
  validates_uniqueness_of :name

  after_create :create_author_performance

  authorizing do |agent, permission|
    if permission == [ :read, :performance ] && others_read_members?
      true
    end
  end

  authorizing do |agent, permission|
    if permission == :create && parent.blank? &&
       new_record? && ! agent.is_a?(SingularAgent)
      true
    end
  end

  authorizing do |agent, permission|
    if parent.present?
      parent.authorize?(permission, :to => agent)
    end
  end
  
  def users
    actors.select{ |a| a.is_a?(User) }
  end

  def email_with_name
    "#{ name } <#{ email }>"
  end

  def notification_emails
    email.present? ?
      Array(email_with_name) :
      users.map(&:notification_emails).flatten
  end

  private

  # Create Performance for the author with the highest role
  def create_author_performance
    Performance.create! :stage => self,
                        :agent => author,
                        :role => self.class.roles.sort.last
  end

end
