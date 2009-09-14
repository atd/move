class Task < ActiveRecord::Base
  include CommonContent

  RECURRENCE = [ :no_recurrence, :dayly, :weekly, :monthly, :yearly ]

  RECURRENCE.each_with_index do |name, index|
    named_scope name, lambda {
      { :conditions => { :recurrence => index } }
    }
  end

  acts_as_resource 
  acts_as_container :contents => [ :turns ]

  has_many :turns, :order => 'position' do
    def sorted_at(t = Time.now)
      return proxy_target if proxy_owner.recurrence == 0

      returning all do |list|
        o = proxy_owner.occurrences(t)

        if o > 0
          o.times do
            list.push list.shift
          end
        else
          o *= -1
          o.times do
            list.unshift list.pop
          end
        end
      end
    end

    def at(t = Time.now)
      sorted_at(t).first
    end
  end

  validates_presence_of :title, :start_at, :recurrence
  validates_inclusion_of :recurrence, :in => 0..(RECURRENCE.length - 1)

  def recurrence_sym
    RECURRENCE[recurrence]
  end

  def recurrence_in_words
    I18n.t recurrence_sym, :scope => 'task.recurrence'
  end

  # Number of ocurrences until t
  def occurrences(t = Time.now)
    return nil if recurrence == 0

    case RECURRENCE[recurrence]
    when :dayly
      ( t.to_date - start_at.to_date ).to_i
    when :weekly
      ( ( t.to_date - start_at.to_date ) / 7 ).to_i
    when :monthly
      mdiff = ( t.to_date.year * 12 + t.to_date.month ) -
        ( start_at.to_date.year * 12 + start_at.to_date.month )

      # Fix current mount ocurrence
      mdiff -= 1 if t < start_at.months_since(mdiff)
      
      mdiff
    when :yearly
      ydiff = t.to_date.year - start_at.to_date.year

      # Fix current year ocurrence
      ydiff -= 1 if start_at.year_since(ydiff) < t
      
      ydiff
    else
      raise "RECURRENCE invalid index: #{ recurrence }"
    end
  end

  def turn_order(turn, t = Time.now)
    return nil if turns.blank? || turn.blank?

    turns.sorted_at.index(turn)
  end

  def next_turn_in_words(turn)
    I18n.t recurrence_sym, :scope => 'task.next_turn', :turn => turn
  end

end
