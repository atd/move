class Logos < ActiveRecord::Migration
  def self.up
    rename_column :logos, :agent_id, :logoable_id
    rename_column :logos, :agent_type, :logoable_type
    add_column :logos, :db_file_id, :integer

    Logo.reset_column_information

    Logo.record_timestamps = false

    require 'action_controller/test_process'

    Logo.all.each do |logo|
      next if logo.parent_id

      if logo.filename =~ /^(user.*|group.*)$/
        logo.destroy
      else
        file = File.join("#{ RAILS_ROOT }/public/files/logos/#{ logo.id }", logo.filename)
        next unless File.exists?(file)
        mime = `file -b --mime-type '#{ file }'`.chomp
        logo.media = ActionController::TestUploadedFile.new(file, mime)
        logo.save!
      end
    end
  end

  def self.down
    rename_column :logos, :logoable_id, :agent_id
    rename_column :logos, :logoable_type, :agent_type
    remove_column :logos, :db_file_id
  end
end
