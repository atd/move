class Audio < ActiveRecord::Base
  include CommonContent

  has_attachment :content_type => [ 'audio/x-wav',
                                    'audio/wav',
                                    'audio/x-vorbis+ogg',
                                    'application/ogg',
                                    'audio/mpeg' ], 
                 :storage => :db_file,
                 :max_size => 1000.megabytes

  acts_as_resource :mime_types => [ :wav, :mpeg, :ogg ],
                   :disposition => :attachment,
                   :has_media => :attachment_fu,
                   :per_page => 15
  
  validates_as_attachment
end
