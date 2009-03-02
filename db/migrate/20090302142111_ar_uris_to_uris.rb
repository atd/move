class ArUrisToUris < ActiveRecord::Migration
  def self.up
    remove_index :ar_uris, :uri
    rename_table :ar_uris, :uris
    add_index :uris, :uri
    rename_column :bookmarks, :ar_uri_id, :uri_id
  end

  def self.down
    remove_index :uris, :uri
    rename_table :uris, :ar_uris
    add_index :ar_uris, :uri
    rename_column :bookmarks, :uri_id, :ar_uri_id
  end
end
