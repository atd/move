class Categorization < ActiveRecord::Base
  belongs_to :categorizable, :polymorphic => true
end

class Category < ActiveRecord::Base
  has_many :categorizations
end

class MergeTagsAndCategories < ActiveRecord::Migration
  def self.up
    add_column :tags, :container_id, :integer
    add_column :tags, :container_type, :string
    add_column :tags, :taggings_count, :integer, :default => 0

    remove_index :tags, :name
    add_index :tags, [ :name, :container_id, :container_type ]

    Tag.reset_column_information

    Tag.all.each do |t|
      Tag.update_counters t.id, :taggings_count => t.taggings.count
    end
   
    # Add Container to Tags
    Tag.all.each do |t|
      t.taggings.each do |ts|
        if ts.taggable_type == "Category"
          ts.taggable.categorizations.each do |cs|
            cs.categorizable.tag_with(cs.categorizable.tags | Array(t.name))
          end
        else
          nt = Tag.find_or_create_by_name_and_container_id_and_container_type(t.name,
                                                                              ts.taggable.owner_id,
                                                                              ts.taggable.owner_type)
          ts.update_attribute :tag, nt
        end
      end
    end

    # 
    Category.all.each do |c|
      c.categorizations.each do |cs|
        cs.categorizable.tag_with(cs.categorizable.tags | Array(c.name.gsub(/[^\w\ \_\-]/, " ").strip.squeeze(" ")))
      end
    end

    drop_table :categories
    drop_table :categorizations
  end

  def self.down
    remove_column :tags, :container_id
    remove_column :tags, :container_type
    remove_column :tags, :taggings_count

    remove_index :tags, :column => [ :name, :container_id, :container_type ]
    add_index :tags, :name

    create_table :categories do |t|
      t.string   :name
      t.text     :description
      t.integer  :domain_id
      t.string   :domain_type
      t.integer  :parent_id
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :categorizations do |t|
      t.integer :category_id
      t.integer :categorizable_id
      t.string  :categorizable_type
    end
  end
end
