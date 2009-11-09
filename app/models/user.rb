class User < ActiveRecord::Base
  acts_as_agent :activation => true,
                :openid_server => true
  acts_as_resource :per_page => 15, :param => :login
  acts_as_container :sources => true
  acts_as_logoable

  attr_accessible :description

  # FIXME: Rails 2.3 nested_attributes
  attr_accessible :_logo

  has_many :articles,  :as => :owner
  has_many :photos,    :as => :owner
  has_many :audios,    :as => :owner
  has_many :bookmarks, :as => :owner
  has_many :documents, :as => :owner
  has_many :tasks,     :as => :owner

  has_many :memberships
  has_many :groups, :through => :memberships, :source => :group
  
  # Space aliases
  alias_attribute :name, :login

  # Collection aliases
  alias_attribute :title, :login

  # Create local ar_uris_of_owning_agents for this user
  # http:// URI is created by default
  # https:// URI is created if SSL is enabled
  # See move tasks exist for later changes
#  def create_identity_ownings
#    uris = [ ArUri.find_or_create_by_uri("http://#{ config[:site_path] }/users/#{ login }") ]
#    uris << ArUri.find_or_create_by_uri("https://#{ config[:site_path] }/users/#{ login }") if config[:ssl_enabled]
#    uris.each do |uri|
#      ar_uris_of_owning_agents << uri unless ar_uris_of_owning_agents.include?(uri)
#    end
#  end

  validates_format_of :login, :with => /^[\w -]+$/

  authorizing do |agent, permission|
    if agent == self
      true
    end
  end

  def email_with_name
    "#{ name } <#{ email }>"
  end

  def notification_emails
    Array(email_with_name)
  end
end
