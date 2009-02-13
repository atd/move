class Audio < ActiveRecord::Base
  has_attachment :content_type => [ 'audio/x-wav', 'audio/wav', 'audio/x-vorbis+ogg', 'application/ogg', 'audio/mpeg' ], 
                 :storage => :db_file,
                 :max_size => 1000.megabytes

  belongs_to :author, :polymorphic => true
  belongs_to :owner, :polymorphic => true
#  acts_as_content :mime_types => attachment_options[:content_type].join(", "),
#                  :mime_type_images => true,
#                  :disposition => :attachment
  
  validates_as_attachment

  #Fix AttachmentFu bug
  def full_filename
    ""
  end
end
