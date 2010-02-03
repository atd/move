class UserAndGroupSubtitles < ActiveRecord::Migration
  def self.up
    add_column :users, :subtitle, :string
    add_column :groups, :subtitle, :string
  end

  def self.down
    remove_column :users, :subtitle
    remove_column :groups, :subtitle
  end
end
