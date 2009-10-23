namespace :cron do
  task :hourly  => [ 'station:sources:import' ]
  task :daily   => [ 'turns:dayly', 'station:openid:gc_ar_store' ]
  task :weekly  => [ 'turns:weekly' ]
  task :monthly => [ 'turns:monthly' ]
  task :yearly  => [ 'turns:yearly' ]
end
