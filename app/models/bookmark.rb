class Bookmark < ActiveRecord::Base
  belongs_to :author, :polymorphic => true
  belongs_to :owner, :polymorphic => true

  belongs_to :uri

  acts_as_resource :per_page => 5
  acts_as_content :reflection => :owner
  acts_as_taggable

  validates_presence_of :uri_id

  def uri=(uri_or_string)
    self.uri_id = case uri_or_string
                  when String
                    Uri.find_or_create_by_uri(uri_or_string).id
                  when Uri
                    uri_or_string.id
                  else
                    raise "Don't know how to handle Bookmark.new.uri=(#{ uri_or_string.inspect })"
                  end
  end
end
