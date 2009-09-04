class Turn < ActiveRecord::Base
  belongs_to :task
  acts_as_list :scope => :task

  belongs_to :responsible, :polymorphic => true

  acts_as_resource 

  validates_presence_of :responsible_id, :responsible_type

  # Polymorphic responsible
  attr_accessor :_responsible_dom_id

  before_validation :_complete_responsible

  private

  def _complete_responsible
    return if _responsible_dom_id.blank?

    res_id, res_class = _responsible_dom_id.split('-')
    self.responsible = res_class.classify.constantize.find(res_id)
  end


end
