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

    create_table :logotypes do |t|
      t.integer  :logotypable_id
      t.string   :logotypable_type
      t.integer  :size
      t.string   :content_type
      t.string   :filename
      t.integer  :height
      t.integer  :width
      t.integer  :parent_id
      t.string   :thumbnail
      t.integer  :db_file_id
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :performances do |t|
      t.integer :agent_id
      t.string  :agent_type
      t.integer :role_id
      t.integer :stage_id
      t.string  :stage_type
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
      t.string   :name,        :default => "CMSplugin powered Rails site"
      t.text     :description
      t.string   :domain,      :default => "cms.example.org"
      t.string   :email,       :default => "admin@example.org"
      t.string   :locale
      t.datetime :created_at
      t.datetime :updated_at
      t.boolean  :ssl,         :default => false
    end

  end

  def self.down
    remove_table :invitations
    remove_table :logotypes
    remove_table :performances
    remove_table :permissions
    remove_table :permissions_roles
    remove_table :roles
    remove_table :singular_agents
    remove_table :sites
  end
end
