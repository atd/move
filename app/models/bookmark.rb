class Bookmark < ActiveRecord::Base
  belongs_to :author, :polymorphic => true
  belongs_to :owner, :polymorphic => true

  belongs_to :ar_uri
#  acts_as_content

#  validates_as_content
  validates_presence_of :ar_uri_id

  def url
    ar_uri ? ar_uri.uri : nil
  end

  def url=(uri)
    self.ar_uri = ArUri.find_or_create_by_uri(uri)
  end
end
