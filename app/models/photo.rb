class Photo < ActiveRecord::Base
  has_attachment :content_type => :image,
                 :storage => :db_file,
                 :max_size => 1000.megabytes,
                 :thumbnails => { :normal => '350>', :thumb => '100' }

  belongs_to :author, :polymorphic => true
  belongs_to :owner, :polymorphic => true

  acts_as_resource :mime_types => [ :jpeg, :gif, :png ],
                   :disposition => :inline,
                   :has_media => :attachment_fu
  acts_as_content :reflection => :owner
  acts_as_taggable

  validates_as_attachment
end
