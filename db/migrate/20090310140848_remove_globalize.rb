class RemoveGlobalize < ActiveRecord::Migration
  def self.up
    drop_table :globalize_countries
    drop_table :globalize_languages
    drop_table :globalize_translations
  end

  def self.down
    create_table :globalize_countries do |t|
    end
    create_table :globalize_languages do |t|
    end
    create_table :globalize_translations do |t|
    end
  end
end
