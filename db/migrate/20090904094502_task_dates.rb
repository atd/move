class TaskDates < ActiveRecord::Migration
  def self.up
    add_column :tasks, :start_at, :datetime
    add_column :tasks, :recurrence, :integer
  end

  def self.down
    remove_column :tasks, :start_at
    remove_column :tasks, :recurrence, :default => 0
  end
end
