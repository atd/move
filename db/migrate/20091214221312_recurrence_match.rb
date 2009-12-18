class RecurrenceMatch < ActiveRecord::Migration
  def self.up
    add_column :tasks, :recurrence_match, :string, :default => ""
    add_column :turns, :recurrence_match, :string, :default => ""
  end

  def self.down
    remove_column :tasks, :recurrence_match
    remove_column :turns, :recurrence_match
  end
end
