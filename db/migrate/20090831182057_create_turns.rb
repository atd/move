class CreateTurns < ActiveRecord::Migration
  def self.up
    create_table :turns do |t|
      t.integer :position
      t.references :task
      t.references :responsible, :polymorphic => true

      t.timestamps
    end
  end

  def self.down
    drop_table :turns
  end
end
