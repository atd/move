namespace :setup do
  namespace :basic do
    desc "Load Basic Data"
    task :data => :roles

    desc "Load Roles Data"
    task :roles => :permissions do
      site_admin_role = Role.find_or_create_by_name_and_stage_type "Admin", "Site"
      site_admin_role.permissions << Permission.find_by_action_and_objective('read',   nil)
      site_admin_role.permissions << Permission.find_by_action_and_objective('update', nil)

      admin_role = Role.find_or_create_by_name_and_stage_type "Admin", "Group"
      admin_role.permissions << Permission.find_by_action_and_objective('read',   nil)
      admin_role.permissions << Permission.find_by_action_and_objective('update', nil)
      admin_role.permissions << Permission.find_by_action_and_objective('delete', nil)
      admin_role.permissions << Permission.find_by_action_and_objective('create', 'content')
      admin_role.permissions << Permission.find_by_action_and_objective('read',   'content')
      admin_role.permissions << Permission.find_by_action_and_objective('update', 'content')
      admin_role.permissions << Permission.find_by_action_and_objective('delete', 'content')
      admin_role.permissions << Permission.find_by_action_and_objective('create', 'performance')
      admin_role.permissions << Permission.find_by_action_and_objective('read',   'performance')
      admin_role.permissions << Permission.find_by_action_and_objective('update', 'performance')
      admin_role.permissions << Permission.find_by_action_and_objective('delete', 'performance')

      participate_role = Role.find_or_create_by_name_and_stage_type "Participate", "Group"
      participate_role.permissions << Permission.find_by_action_and_objective('read',   nil)
      participate_role.permissions << Permission.find_by_action_and_objective('create', 'content')
      participate_role.permissions << Permission.find_by_action_and_objective('read',   'content')
      participate_role.permissions << Permission.find_by_action_and_objective('update', 'content')
      participate_role.permissions << Permission.find_by_action_and_objective('create', 'performance')
      participate_role.permissions << Permission.find_by_action_and_objective('read',   'performance')

      observe_role = Role.find_or_create_by_name_and_stage_type "Observe", "Group"
      observe_role.permissions << Permission.find_by_action_and_objective('read', nil)
      observe_role.permissions << Permission.find_by_action_and_objective('read', 'content')
      observe_role.permissions << Permission.find_by_action_and_objective('read', 'performance')
    end

    desc "Load Basic Permissions"
    task :permissions => :environment do
      # Permissions applied to self
      %w( read update delete ).each do |action|
        Permission.find_or_create_by_action_and_objective action, nil
      end

      # Permissions applied to Content and Performance
      %w( create read update delete ).each do |action|
        %w( content performance ).each do |objective|
          Permission.find_or_create_by_action_and_objective action, objective
        end
      end
    end

    desc "Load Basic data in test"
    task :test => "db:test:prepare" do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])
      ActiveRecord::Schema.verbose = false
      Rake::Task["setup:basic:data"].invoke
   end
  end
end
