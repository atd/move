class IdentityOwning < ActiveRecord::Base
  belongs_to :owning_agent, :polymorphic => true
  belongs_to :ar_uri

  validates_presence_of :owning_agent_id, :owning_agent_type, :ar_uri_id
end
