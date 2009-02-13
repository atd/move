class Membership < ActiveRecord::Base
  belongs_to :member, :polymorphic => true
  belongs_to :set, :polymorphic => true
  belongs_to :profile

#  acts_as_double_polymorphic_join :members => config[ :cms_agents ],
#                                  :sets => config[ :cms_agent_sets ],
#                                  :rename_individual_collections => true

  validates_presence_of :member_id, 
                        :member_type, 
                        :set_id, 
                        :set_type
  validates_uniqueness_of :member_id, :scope => [ :member_type, :set_id, :set_type ]
  validates_uniqueness_of :set_id, :scope => [ :set_type, :member_id, :member_type ]
end
