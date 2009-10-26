namespace :icons do
  namespace :oxygen do
    desc "Copy oxygen icons from /usr/share/icons/oxygen to public/images/models"
    task :copy do
      icons = YAML.load_file("#{ RAILS_ROOT }/config/oxygen-icons.yml")

      # Mimetypes
      icons['mime_types'].each do |mime_type|
        puts mime_type
        icons['resource_sizes'].each do |size|
          command = "cp "
          command += File.join(icons['source_dir'], "#{ size }x#{ size }", "mimetypes", mime_type)
          command += " "
          command += File.join(RAILS_ROOT, icons['destination_dir'], size.to_s)

          system command
        end
      end

      # Resources
      icons['resources'].each do |resource|
        puts resource['name']
        icons['resource_sizes'].each do |size|
          command = "cp "
          command += File.join(icons['source_dir'], "#{ size }x#{ size }", resource['dir'], resource['file'])
          command += " "
          command += File.join(RAILS_ROOT, icons['destination_dir'], size.to_s, resource['name'])

          system command
        end
      end
    end
  end
end
