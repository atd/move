class SourceImports < ActiveRecord::Migration
  def self.up
    create_table :source_importations do |t|
      t.references :source
      t.references :importation, :polymorphic => true
      t.string     :guid

      t.timestamps
    end

    add_column :sources, :public_read, :boolean

    remove_column :article_versions, :guid
    remove_column :articles, :guid
  end

  def self.down
    drop_table :source_importations

    remove_column :sources, :public_read

    add_column :article_versions, :guid, :string
    add_column :articles, :guid, :string
  end
end
