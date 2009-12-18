class Task < ActiveRecord::Base
  include CommonContent

  RECURRENCE       = [ :no_recurrence, :dayly, :weekly, :monthly, :yearly ]
  # NOTE: RECURRENCE_MATCH is only implemented for weeks
  RECURRENCE_MATCH = /(-?[1-5]) ([1-7])/

  # Create a named_scope for each recurrence: dayly, weekly, etc..
  RECURRENCE.each_with_index do |name, index|
    named_scope name, lambda {
      { :conditions => { :recurrence => index } }
    }
  end

  named_scope :email_notifications, lambda {
    { :conditions => { :email_notifications => true } }
  }

  named_scope :without_recurrence_match, lambda {
    { :conditions => { :recurrence_match => "" } }
  }

  validates_presence_of :title, :start_at, :recurrence
  validates_inclusion_of :recurrence, :in => 0..(RECURRENCE.length - 1)
  validates_format_of :recurrence_match, :with => RECURRENCE_MATCH, :allow_blank => true

  has_many :turns, :order => 'position' do
    def fix_last
      # Fix a least half of the turns
      fix_range = (count / 2.0).ceil

      case proxy_owner.recurrence_sym
      when :weekly
        all.last(fix_range).reverse.each do |t|
          next if t.recurrence_match.blank?

          ((count - fix_range + 1)..count).each do |tn|
            turn_date = Date.today.since((tn - 1).weeks).to_date
            t.insert_at(tn) if proxy_owner.match_recurrence?(turn_date, t.recurrence_match)
          end
        end
      end
    end
  end

  acts_as_resource 
  acts_as_container :contents => [ :turns ]

  def next_turn_in_words(turn)
    I18n.t recurrence_sym, :scope => 'task.next_turn', :turn => turn
  end

  def recurrence_sym
    RECURRENCE[recurrence]
  end

  def recurrence_in_words
    I18n.t recurrence_sym, :scope => 'task.recurrence'
  end

  # Options:
  # author:: who is rotating turns (for Cron tasks)
  def rotate(options = {})
    return if recurrence_sym == :no_recurrence

    if turns.any?
      turns.first.move_to_bottom
      turns.fix_last
    end

    if options[:author].present?
      update_attribute :author, options[:author]
    end

    touch
  end

  # Array of order, day of the week
  #
  # NOTE: RECURRENCE_MATCH is only implemented for weeks
  def recurrence_order_and_day(r = self.recurrence_match)
    RECURRENCE_MATCH.match(r).captures.map{ |i| i.try(:to_i) }
  end

  # Does recurrence coincide with date?
  # Currently only weekly recurrence supported
  def match_recurrence?(date = Date.today, rm = self.recurrence_match)
    return false if rm.blank?

    order, day = recurrence_order_and_day(rm)

    date_in_wday = date.to_date + day - date.to_date.wday

    if order > 0
      order == (date_in_wday.mday / 7.0).ceil
    else
      order == ((date_in_wday - date_in_wday.next_month.beginning_of_month) / 7.0).floor
    end
  end

  def parse(attribute, turn = turns.first)
    raise "Invalid attribute" unless [ :email_subject, :email_body ].include?(attribute)

    return "" if (msg = send(attribute)).blank?

    if turn.present?
      msg.gsub(
       '@responsibles',      turn.responsibles.map(&:name).join(" - ")).gsub(
       '@responsible_users', turn.responsible_users.map(&:name).join(" - "))
    else
      msg
    end
  end

  def notification_emails
    turns.any? ?
      turns.first.responsibles.map(&:notification_emails).flatten :
      container.notification_emails
  end
end
