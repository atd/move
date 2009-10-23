namespace :turns do
  desc "Send dayly turns emails"
  task :dayly => :environment do
    Task.dayly.each{ |t| TaskMailer.deliver_next_turn(t) }
  end

  desc "Send weekly turns emails"
  task :weekly => :environment do
    Task.weekly.each{ |t| TaskMailer.deliver_next_turn(t) }
  end

  desc "Send monthly turns emails"
  task :monthly => :environment do
    Task.monthly.each{ |t| TaskMailer.deliver_next_turn(t) }
  end

  desc "Send yearly turns emails"
  task :yearly => :environment do
    Task.yearly.each{ |t| TaskMailer.deliver_next_turn(t) }
  end
end
