class TaskMails < ActiveRecord::Migration
  def self.up
    add_column :tasks, :email_notifications, :boolean
    add_column :tasks, :email_subject, :string
    add_column :tasks, :email_body, :text
  end

  def self.down
  end
end
