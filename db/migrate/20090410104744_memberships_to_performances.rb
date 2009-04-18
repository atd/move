class MembershipsToPerformances < ActiveRecord::Migration
  def self.up
    rename_table :memberships, :performances
    rename_column :performances, :member_id, :agent_id
    rename_column :performances, :member_type, :agent_type
    rename_column :performances, :set_id, :stage_id
    rename_column :performances, :set_type, :stage_type
    add_column :performances, :role_id, :integer

    admin, participant = create_roles
    Performance.all.each do |p|
      p.update_attribute :role, (p.stage.user == p.agent ? admin : participant)
    end
  end

  def self.down
    remove_column :performances, :role_id
    rename_column :performances, :agent_id, :member_id
    rename_column :performances, :agent_type, :member_type
    rename_column :performances, :stage_id, :set_id
    rename_column :performances, :stage_type, :set_type
    rename_table :performances, :memberships
  end

  def self.create_roles
    part_perm = []
    part_perm << Permission.find_or_create_by_action_and_objective('create', 'content')
    part_perm << Permission.find_or_create_by_action_and_objective('read', 'content')
    part_perm << Permission.find_or_create_by_action_and_objective('update', 'content')
    part_perm << Permission.find_or_create_by_action_and_objective('delete', 'content')
    part_perm << Permission.find_or_create_by_action_and_objective('create', 'performance')
    part_perm << Permission.find_or_create_by_action_and_objective('read', 'performance')
    part_perm << Permission.find_or_create_by_action('read')

    admin_perm = part_perm.dup
    admin_perm << Permission.find_or_create_by_action_and_objective('update', nil)
    admin_perm << Permission.find_or_create_by_action_and_objective('delete', nil)
    admin_perm << Permission.find_or_create_by_action_and_objective('update', 'performance')
    admin_perm << Permission.find_or_create_by_action_and_objective('delete', 'performance')
    p = Role.find_or_create_by_name_and_stage_type("Participant", "Group")
    p.permissions = part_perm
    a = Role.find_or_create_by_name_and_stage_type("Admin", "Group")
    a.permissions = admin_perm

    Role.find_or_create_by_name_and_stage_type("Admin", "Site").permissions = admin_perm

    [ a, p ]
  end
end
