class Group < ActiveRecord::Base
  belongs_to :user
  acts_as_container

#  acts_as_agent :has_logo => true
#  has_space

  # Collection aliases
  alias_attribute :title, :name

  def read_by?(agent)
    others_read_content? || members_read_content? && self.includes?(agent) || self.user == agent
  end

  def write_by?(agent)
    others_write_content? || members_write_content? && self.includes?(agent) || self.user == agent
  end

  def exec_by?(agent)
    others_read_content? || members_read_content? && self.includes?(agent) || self.user == agent
  end


  def includes?(member)
    # A group includes itself
    return true if member == self

    members.each do |m|
      return true if m == member || m.respond_to?(:includes?) && m.includes?(member)
    end

    false
  end

  def has_owner?(agent)
    self.includes?(agent) && self.read_by?(agent) && self.write_by?(agent)
  end

  def members_can_be_read_by?(agent)
    others_read_members? || members_read_members? && self.includes?(agent) || self.user == agent
  end

  def members_can_be_writen_by?(agent)
    others_write_members? || members_write_members? && self.includes?(agent) || self.user == agent
  end

  #FIXME Delete this when fixing properties
  def last_online_list
    return []
    users = []
    memberships.each do |m|
      if not m.profile.nil? and m.profile.last_online?
        users << m.member
      else
        u = m.member
        u.last_online = nil
        users << u
      end if m.member.is_a? User
    end
    users
  end
  
  ##############
  # Pagination #
  ##############
  cattr_reader :per_page
  @@per_page = 9

  private

  validates_presence_of :name
  validates_uniqueness_of :name
end
