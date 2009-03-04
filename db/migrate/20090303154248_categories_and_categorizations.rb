class CategoriesAndCategorizations < ActiveRecord::Migration
  def self.up
    rename_column :categories, :title, :name
    rename_column :categories, :owner_id, :domain_id
    rename_column :categories, :owner_type, :domain_type
    rename_column :categories, :parent, :parent_id
    rename_column :categorizations, :content_id, :categorizable_id
    rename_column :categorizations, :content_type, :categorizable_type
  end

  def self.down
    rename_column :categories, :name, :title
    rename_column :categories, :domain_id, :owner_id
    rename_column :categories, :domain_type, :owner_type
    rename_column :categories, :parent_id, :parent
    rename_column :categorizations, :categorizable_id, :content_id
    rename_column :categorizations, :categorizable_type, :content_type
  end
end
