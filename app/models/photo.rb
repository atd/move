class Photo < ActiveRecord::Base
  has_attachment :content_type => :image,
                 :storage => :db_file,
                 :max_size => 1000.megabytes,
                 :thumbnails => { :normal => '350>', :thumb => '100' }

  belongs_to :author, :polymorphic => true
  belongs_to :owner, :polymorphic => true
#  acts_as_content :mime_types => attachment_options[:content_type].join(", "),
#                  :disposition => :inline

  validates_as_attachment
#  validates_as_content

  #Fixes AttachmentFu bug
  def full_filename
    ""
  end
end
