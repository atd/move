class GlobalGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :global, :boolean, :default => false
  end

  def self.down
    remove_column :groups, :global
  end
end
