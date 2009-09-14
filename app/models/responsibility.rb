class Responsibility < ActiveRecord::Base
  belongs_to :turn
  belongs_to :responsible, :polymorphic => true

  validates_presence_of :responsible_id, :responsible_type
end
