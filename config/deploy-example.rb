set :application, "move"
set :repository,  "git://github.com/atd/move.git"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :git_enable_submodules, 1

#role :app, "your app-server here"
#role :web, "your web-server here"
#role :db,  "your db-server here", :primary => true

after 'deploy:update_code', 'deploy:link_files'
after 'deploy:update_code', 'deploy:fix_file_permissions'

namespace(:deploy) do
  # Running as www-data
  task :fix_file_permissions do
    # AttachmentFu dir is deleted in deployment
    run  "/bin/mkdir -p #{ release_path }/tmp/attachment_fu"
    # Make tmp/ writtable by group
    sudo "/bin/chmod -R g+w #{ release_path }/tmp"
    # Set tmp/ group to www-data
    sudo "/bin/chgrp -R www-data #{ release_path }/tmp"
  end

  task :link_files do
    # Database configuration
    run "ln -sf #{ shared_path }/config/database.yml #{ release_path }/config/"
    # Public Logos
    run "ln -sf #{ shared_path }/public/logos #{ release_path }/public/"
    # AttachmentFu files
    run "ln -sf #{ shared_path }/files #{ release_path }/files/"
  end

  desc "Restarting mod_rails with restart.txt"
    task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

