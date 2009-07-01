class CommentsToPosts < ActiveRecord::Migration
  def self.up
    rename_table :comments, :posts
    rename_column :posts, :commentable_id, :postable_id
    rename_column :posts, :commentable_type, :postable_type
    rename_column :posts, :content, :text
  end

  def self.down
    rename_column :posts, :postable_id, :commentable_id
    rename_column :posts, :postable_type, :commentable_type
    rename_column :posts, :text, :content
    rename_table :posts, :comments
  end
end
