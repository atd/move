class ToCmsplugin < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.string   :code
      t.string   :email
      t.integer  :agent_id
      t.string   :agent_type
      t.integer  :stage_id
      t.string   :stage_type
      t.integer  :role_id
      t.string   :acceptation_code
      t.datetime :accepted_at
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :permissions do |t|
      t.string :action
      t.string :objective
    end

    create_table :permissions_roles, :id => false do |t|
      t.integer :permission_id
      t.integer :role_id
    end

    create_table :roles do |t|
      t.string  :name
      t.string  :stage_type
    end

    create_table :singular_agents do |t|
      t.string :type
    end

    create_table :sites do |t|
      t.string   :name,        :default => "MOVE"
      t.text     :description
      t.string   :domain,      :default => "move.example.org"
      t.string   :email,       :default => "admin@example.org"
      t.string   :locale
      t.datetime :created_at
      t.datetime :updated_at
      t.boolean  :ssl,         :default => false
    end

  end

  def self.down
    drop_table :invitations
    drop_table :permissions
    drop_table :permissions_roles
    drop_table :roles
    drop_table :singular_agents
    drop_table :sites
  end
end
