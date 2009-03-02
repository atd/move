class Audio < ActiveRecord::Base
  has_attachment :content_type => [ 'audio/x-wav',
                                    'audio/wav',
                                    'audio/x-vorbis+ogg',
                                    'application/ogg',
                                    'audio/mpeg' ], 
                 :storage => :db_file,
                 :max_size => 1000.megabytes

  belongs_to :author, :polymorphic => true
  belongs_to :owner, :polymorphic => true

  acts_as_resource :mime_types => [ :wav, :mpeg, :ogg ],
                   :disposition => :attachment,
                   :has_media => :attachment_fu
  acts_as_content :reflection => :owner
  acts_as_taggable
  
  validates_as_attachment
end
