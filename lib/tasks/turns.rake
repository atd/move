namespace :turns do
  desc "Send dayly turns emails"
  task :dayly => :environment do
    Task.email_notifications.dayly.each{ |t|
      t.rotate(:author => CronAgent.current)
      TaskMailer.deliver_notification(t)
    }
  end

  desc "Send weekly turns emails"
  task :weekly => :environment do
    # 
    # Weekly Tasks
    #
    Task.email_notifications.weekly.each{ |t|
      t.rotate(:author => CronAgent.current)
      TaskMailer.deliver_notification(t)
    }
    #
    # Monthly Tasks with recurrence
    #
    # OPTIMIZE: with_recurrence_match named scope
    Task.email_notifications.monthly.select{ |t|
      t.match_recurrence?
    }.each do |t|
      t.rotate(:author => CronAgent.current)
      TaskMailer.deliver_notification(t)
    end
  end

  desc "Send monthly turns emails"
    #
    # Monthly Tasks without recurrence
    #
  task :monthly => :environment do
    Task.email_notifications.monthly.without_recurrence_match.each{ |t|
      t.rotate(:author => CronAgent.current)
      TaskMailer.deliver_notification(t)
    }
  end

  desc "Send yearly turns emails"
  task :yearly => :environment do
    Task.email_notifications.yearly.each{ |t|
      t.rotate(:author => CronAgent.current)
      TaskMailer.deliver_notification(t)
    }
  end
end
