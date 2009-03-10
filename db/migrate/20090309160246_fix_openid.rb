class FixOpenid < ActiveRecord::Migration
  def self.up
    rename_table :identity_ownings, :open_id_ownings
    rename_column :open_id_ownings, :owning_agent_id, :agent_id
    rename_column :open_id_ownings, :owning_agent_type, :agent_type
    rename_column :open_id_ownings, :ar_uri_id, :uri_id

    rename_table :identity_trusts, :open_id_trusts
    rename_column :open_id_trusts, :user_id, :agent_id
    add_column :open_id_trusts, :agent_type, :string
    add_column :open_id_trusts, :local, :boolean, :default => false
    rename_column :open_id_trusts, :ar_uri_id, :uri_id

    drop_table :openid_users
  end

  def self.down
    rename_column :open_id_ownings, :agent_id, :owning_agent_id
    rename_column :open_id_ownings, :agent_type, :owning_agent_type
    rename_column :open_id_ownings, :uri_id, :ar_uri_id
    rename_table :open_id_ownings, :identity_ownings

    rename_column :open_id_trusts, :agent_id, :user_id
    remove_column :open_id_trusts, :agent_type
    remove_column :open_id_trusts, :local
    rename_column :open_id_trusts, :uri_id, :ar_uri_id
    rename_table :open_id_trusts, :identity_trusts

    create_table :openid_users do |t|
      t.integer  :identity_uri_id
      t.string   :nickname
      t.string   :email
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
