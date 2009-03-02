class User < ActiveRecord::Base
  acts_as_agent
  acts_as_container

  has_many :groups
  
  # Space aliases
  alias_attribute :name, :login

  # Collection aliases
  alias_attribute :title, :login

  # OpenID trusts
#  has_many :identity_trusts, :dependent => :destroy
#  has_many :trusted_uris, :through => :identity_trusts,
#                          :source => :ar_uri,
#                          :uniq => true

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

  validates_length_of       :login,    :within => 1..40
end
