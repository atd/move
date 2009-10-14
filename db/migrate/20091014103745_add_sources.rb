class AddSources < ActiveRecord::Migration
  def self.up
    create_table :sources do |t|
      t.references :uri
      t.string     :content_type
      t.string     :target
      t.references :container, :polymorphic => true
      t.datetime   :imported_at

      t.timestamps
    end

    add_column :articles, :guid, :string
    add_column :article_versions, :guid, :string
  end

  def self.down
    drop_table :sources

    remove_column :articles, :guid
    remove_column :article_versions, :guid
  end
end
