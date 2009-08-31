class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.integer :offset, :default => 0
      t.references :owner, :polymorphic => true
      t.references :author, :polymorphic => true
      t.boolean :public_read

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
