class Responsibilities < ActiveRecord::Migration
  def self.up
    create_table :responsibilities do |t|
      t.references :turn
      t.references :responsible, :polymorphic => true
    end

    remove_column :turns, :responsible_id
    remove_column :turns, :responsible_type
  end

  def self.down
    drop_table :responsibilities

    add_column :turns, :responsible_id, :integer
    add_column :turns, :responsible_type, :string
  end
end
