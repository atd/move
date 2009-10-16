namespace :cron do
  task :hourly => [ 'station:sources:import' ]
  task :daily  => [ 'station:openid:gc_ar_store' ]
end
