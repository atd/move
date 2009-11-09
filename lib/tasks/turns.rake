namespace :turns do
  desc "Send dayly turns emails"
  task :dayly => :environment do
    Task.email_notifications.dayly.each{ |t|
      TaskMailer.deliver_next_turn(t)
      t.update_attribute :author, CronAgent.current
    }
  end

  desc "Send weekly turns emails"
  task :weekly => :environment do
    Task.email_notifications.weekly.each{ |t|
      TaskMailer.deliver_next_turn(t)
      t.update_attribute :author, CronAgent.current
    }
  end

  desc "Send monthly turns emails"
  task :monthly => :environment do
    Task.email_notifications.monthly.each{ |t|
      TaskMailer.deliver_next_turn(t)
      t.update_attribute :author, CronAgent.current
    }
  end

  desc "Send yearly turns emails"
  task :yearly => :environment do
    Task.email_notifications.yearly.each{ |t|
      TaskMailer.deliver_next_turn(t)
      t.update_attribute :author, CronAgent.current
    }
  end
end
