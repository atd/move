class Turn < ActiveRecord::Base
  belongs_to :task
  acts_as_list :scope => :task

  has_many :responsibilities, :dependent => :destroy
  has_many :responsibles, :through => :responsibilities, :source_type => 'Group'

  acts_as_resource 

  accepts_nested_attributes_for :responsibilities

  # Quick dirty dreadful hack
  def responsibilities_attributes_with_awful_hack=(attributes)
    if attributes.present? &&
       attributes.size == 1 &&
       attributes['0'].present? &&
       attributes['0'][:responsible_id].is_a?(Array)
      ids = attributes['0'][:responsible_id]

      attributes = HashWithIndifferentAccess.new

      ids.each_with_index do |id, index|
        attributes[index.to_s] = { :responsible_id => id,
                              :responsible_type => 'Group' }
      end
    end

    self.responsibilities_attributes_without_awful_hack = attributes
  end
  alias_method_chain :responsibilities_attributes=, :awful_hack

  def at_in_words
    I18n.t task.recurrence_sym, :scope => 'turn.at', :count => task.turn_order(self)
  end

  def validate
    errors.add(:responsibilities, :blank) if responsibilities.blank?
  end

  def responsible_users
    find_users(responsibles.to_a).flatten.uniq
  end

  private

  def find_users(o)
    case o
    when Array
      o.map{ |e| find_users(e) }
    when Group
      o.users
    when User
      o
    else
      raise "Unknow object #{ o.inspect }"
    end
  end
end
