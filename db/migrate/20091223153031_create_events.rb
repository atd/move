class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :title
      t.text :description
      t.datetime :start_at
      t.datetime :end_at
      t.references :owner, :polymorphic => true
      t.references :author, :polymorphic => true

      t.boolean :public_read

      t.timestamps
    end

    create_table :attendances do |t|
      t.references :user
      t.references :event
    end
  end

  def self.down
    drop_table :events
    drop_table :attendances
  end
end
